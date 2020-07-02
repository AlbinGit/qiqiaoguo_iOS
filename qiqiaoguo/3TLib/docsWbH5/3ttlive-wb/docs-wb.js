var documentBody = document.getElementsByTagName('body')[0];

var urlParams = parseURL(location.href).params;
var ua = navigator.userAgent.toLowerCase();
var isMobile = /phone|pad|pod|iphone|ipod|ios|ipad|android|mobile|blackberry|iemobile|mqqbrowser|juc|fennec|wosbrowser|browserng|webos|symbian|windows phone/i.test(ua);
var isWindows = !!(urlParams.referer && urlParams.referer === 'windows' || /windows nt/i.test(ua));
var isIos = !!(urlParams.referer && urlParams.referer === 'ios' || /\(i[^;]+;( u;)? cpu.+mac os x/i.test(ua));
var isAndroid = !!(urlParams.referer && urlParams.referer === 'android' || ua.indexOf('android') > -1 || ua.indexOf('adr') > -1);
var isMiniProgram = urlParams.referer === 'weapp';
var toRotate = urlParams.rotate === '1' || (isMiniProgram && documentBody.clientWidth < documentBody.clientHeight);
var platform = isMiniProgram ? 'miniprogram' : isWindows ? 'windows' : isIos ? 'ios' : isAndroid ? 'android' : 'unknown';
var version = '2.0.12';
var log = urlParams.log || true;
var userId = +urlParams.userid;
var roomId = +urlParams.classid;
var role = +urlParams.role;
var appId = urlParams.appid;

var userName = decodeURIComponent(urlParams.username || '');
var apiDomain;
var ipLocationUrl = (window.ipLocation && window.ipLocation.value) || urlParams.iplocation;
if (ipLocationUrl) {
    apiDomain = /^https?:\/\/[\w-.]+(:\d+)?/i.exec(ipLocationUrl)[0];
} else {
    apiDomain = location.host === 'yunapi.qiqiaoguo.com'
        ? 'https://yunim.qiqiaoguo.com'
        : location.host === 'api3tclass.3ttech.cn'
            ? 'https://eduim.3ttech.cn'
            : location.host === 'preapi3tclass.3ttech.cn'
                ? 'https://preim.3ttech.cn'
                : 'https://devim.3ttech.cn';
    ipLocationUrl = apiDomain + '/server/location';
}

var slideId = 0;            // 课件id
var currentPage = 0;        // 当前页
var totalPage = 0;          // 总页码
var pageCurrentStep = 0;    // 当前页总步数
var pageTotalStep = 0;      // 当前步

var slideOrigin = '*'       // 课件 origin
var slidesMap = {};         // 课件 Map
var slideType = 'img';      // 课件广播类型  'wb'白板、'img'图片、'h5'pptH5
var initPageStr = '0';      // 初始的 pageStr
var pageStr = '0';          // 白板: "0"  课件: "{slideId}_{currentPage}"
var pptIframe = document.getElementById('ifr');
var isPlaying = false;      // ppt 是否正在播放
var isPptReady = false;     // pptH5 ready
var redressTimer = false;      // pptH5 同步定时器
var sourceWs = null;        // 白板的源 websocket 实例
var isLastOperate = false;  // 自己是否是最后一次操作 ppt 的人（教师或助教），用来同步异常的 ppt 状态 & 幻灯片改变，广播信令（谁操作的谁广播）
var serverStatus = { slideId: 0, page: 0, step: 0 };  // 服务器课件状态
var preloadImg = new Image();   // 图片课件的加载容器，以从 onload 中获取图片的尺寸
var contralBtnDisabled = false; // 翻页等函数的禁用状态（这些控制课件的函数调用间隔不可小于 100ms）

var syncIframe = null;      // 用来给 windows 客户端触发同步页码的 iframe
var syncIframeCount = 0;
var logCount = 0;
var logBuffer = [];

/**
 * 上一页
 */
function prevPage() {
    try {
        if (contralBtnDisabled) {
            return -1;
        }
        log && console.log('Call prevPage: ', Array.prototype.slice.call(arguments));
        disableContralBtn();
        if (currentPage <= 1) {
            return +currentPage;
        }
        currentPage--;
        if (slideType === 'img') {
            changeDocumentContent();
        } else {
            pageCurrentStep = slidesMap[slideId][currentPage] || 0;
            changeDocumentH5Content(1);
        }
        return +currentPage;
    } catch (error) {
        outsideCallError(error);
        return -1;
    }
}
var previousPage = prevPage;

/**
 * 下一页
 */
function nextPage() {
    try {
        if (contralBtnDisabled) {
            return -1;
        }
        log && console.log('Call nextPage: ', Array.prototype.slice.call(arguments));
        disableContralBtn();
        if (currentPage >= totalPage) {
            return +currentPage;
        }
        currentPage++;
        if (slideType === 'img') {
            changeDocumentContent();
        } else {
            pageCurrentStep = slidesMap[slideId][currentPage] || 0;
            changeDocumentH5Content(2)
        }
        return +currentPage;
    } catch (error) {
        outsideCallError(error);
        return -1;
    }
}

/**
 * 上一步
 */
function prevStep() {
    try {
        if (contralBtnDisabled) {
            return -1;
        }
        log && console.log('Call prevStep: ', Array.prototype.slice.call(arguments));
        disableContralBtn();
        var turnPage = pageCurrentStep === 0;
        if (turnPage) {
            currentPage--;
        } else {
            pageCurrentStep--;
        }
        changeDocumentH5Content(3)
        return +currentPage;
    } catch (error) {
        outsideCallError(error);
        return -1;
    }
}
var previousStep = prevStep

/**
 * 下一步
 */
function nextStep() {
    try {
        if (contralBtnDisabled) {
            return -1;
        }
        log && console.log('Call nextStep: ', Array.prototype.slice.call(arguments));
        disableContralBtn();
        var turnPage = pageCurrentStep >= pageTotalStep;
        if (turnPage) {
            currentPage = Math.min(currentPage + 1, totalPage);
        } else {
            pageCurrentStep++;
        }
        changeDocumentH5Content(4)
        return +currentPage
    } catch (error) {
        outsideCallError(error);
        return -1;
    }
}

/**
 * 跳转到某页
 * @param {number} page 跳转页
 * @param {number} step 跳转步
 */
function jumpPage(page, step) {
    try {
        if (contralBtnDisabled) {
            return -1;
        }
        log && console.log('Call jumpPage: ', Array.prototype.slice.call(arguments));
        disableContralBtn();
        currentPage = +page;
        pageCurrentStep = +step || 0
        if (slideType === 'img') {
            changeDocumentContent();
        } else {
            changeDocumentH5Content(5);
        }
        return +page;
    } catch (error) {
        outsideCallError(error);
        return -1;
    }
}

/**
 * 一键切换到白板
 */
function switchWhiteBoard() {
    try {
        log && console.log('Call switchWhiteBoard: ', Array.prototype.slice.call(arguments));
        if (!board) {
            return false;
        }
        isLastOperate = true;
        if (slideType === 'img') {
            changeSlideImg('');
            pptIframe.setAttribute('width', containerWidth);
            pptIframe.setAttribute('height', containerHeight);
            board.setOption({width: containerWidth, height: containerHeight, write: true});//设置画布宽高
        } else {
            if (isMiniProgram) {
                pptIframe = $('<iframe id="ifr" style="position:absolute;" frameborder="0" scrolling="no" width="' + containerWidth + '" height="' + containerHeight + '" name="myframe" src="about:blank" allow="autoplay;encrypted-media"></iframe>')[0];
                $("#ifr").remove();
                $("#canvas").prepend(newIframe);
            } else {
                pptIframe.src = 'about:blank';
            }
        }
        currentPage = 0;
        totalPage = 0;
        slideId = 0;
        slideType = 'wb';
        pageCurrentStep = 0;
        pageTotalStep = 0;
        changePage('0');
        sendImgChangeSql();
        return true;
    } catch (error) {
        outsideCallError(error);
        return false;
    }
}

/**
 * 打开课件，显示第一张图片并广播
 * @param docsJson 课件内容json
 * @param current 页码
 * @param step 第几步
 */
function docsOpen(docsJson, page, step) {
    try {
        log && console.log('Call docsOpen: ', Array.prototype.slice.call(arguments))
        isLastOperate = true;
        var docObj = JSON.parse(docsJson);
        slideId = +docObj.id;
        slidesMap[slideId] = Object.assign(slidesMap[slideId] || {}, docObj);
        totalPage = +docObj.page;
        currentPage = +page || 1;
        pageCurrentStep = typeof step === 'number' ? step : slidesMap[slideId][currentPage] || 0;
        slideType = docObj.htmlUrl ? 'h5' : 'img';
        // 打开课件、切换课件内容
        if (slideType == 'img') {
            if (isMiniProgram) {
                $(pptIframe).remove();
                pptIframe = $('<iframe id="ifr" style="position:absolute;" frameborder="0" scrolling="no" width="' + containerWidth + '" height="' + containerHeight + '" name="myframe" src="about:blank" allow="autoplay;encrypted-media"></iframe>')[0];
                $("#canvas").prepend(pptIframe);
            } else {
                pptIframe.src = 'about:blank';
            }
            changeDocumentContent();
        } else {
            pptIframe.setAttribute('width', containerWidth);
            pptIframe.setAttribute('height', containerHeight);
            board.setOption({ width: containerWidth, height: containerHeight, write: true }); // 设置画布宽高
            changeDocumentH5Content(-1);  // + "?r=" + Math.random()
        }
        return true;
    } catch (error) {
        outsideCallError(error);
        return false;
    }
}

/**
 * 白板课件自适应宽度
 * @param width
 */
function changeWhiteBoardWidth(width) {
    try {
        log && console.log('Call changeWhiteBoardWidth: ', Array.prototype.slice.call(arguments))
        if (!board) {
            return false;
        }
        width = parseInt(width);
        var oldWidth = containerWidth;
        if (width != containerWidth) {
            containerWidth = width;
            containerHeight = containerWidth * 9 / 16;
            $('.container').width(containerWidth);
            $('.container').height(containerHeight);
            pptIframe.setAttribute('width', containerWidth);
            pptIframe.setAttribute('height', containerHeight);
            var zoom = containerWidth / oldWidth;
            var boardHeight = board.getOptions().height * zoom;
            board.setOption({width: containerWidth, height: boardHeight, write: true});  // 设置画布宽高
            var zoomRatio = containerWidth / originBoardWidth || 0.01;
            board.changeZoom([0, 0], zoomRatio);    // 缩放画布上图形显示比例
        }
        return true;
    } catch (error) {
        outsideCallError(error);
        return false;
    }
}

function resizeAdapt() {
    try {
        var oldWidth = containerWidth;
        var size = getNewContainerSize(toRotate);
        containerWidth = size.width;
        containerHeight = size.height;
    
        if (oldWidth != containerWidth) {
            $('.container').width(containerWidth);
            $('.container').height(containerHeight);
            pptIframe.setAttribute('width', containerWidth);
            pptIframe.setAttribute('height', containerHeight);
            if (board) {
                var oldZoomRatio = oldWidth / originBoardWidth;
                var oldBoardHeight = board.getOptions().height;
                var zoomRatio = containerWidth / originBoardWidth || 0.01;
                var boardHeight = oldBoardHeight / oldZoomRatio * zoomRatio;
                board.setOption({width: containerWidth, height: boardHeight, write: true});  // 设置画布宽高
                board.changeZoom([0, 0], zoomRatio);    // 缩放画布上图形显示比例
            }
        }
        return true;
    } catch (error) {
        nativeCallback('onError', {
            type: 'UNEXPECTED_ERROR',
            message: 'resizeAdapt error: ' + error.stack
        });
        return false;
    }
}

/**
 * 设置白板工具
 * @param {string} toolType 工具类型
 * @param {object} options 工具选项
 */
function boardSetTool(toolType, options) {
    try {
        log && console.log('Call boardSetTool: ', Array.prototype.slice.call(arguments))
        if (!boardInited) {
            return false;
        }
        var stroke = options && options.stroke ? options.stroke : 'red';
        var strokeWidth = options && options.strokeWidth ? options.strokeWidth : 2;
        var fontSize = options && options.fontSize ? options.fontSize : 15;
        var customOffsetX = -$(".container").offset().left;
        var customOffsetY = -$(".container").offset().top;
        switch (toolType) {
            case 'SingleSyncPen'://画笔
                board.setTool("SingleSyncPen",
                    {
                        stroke: stroke,
                        strokeWidth: options && options.strokeWidth ? options.strokeWidth : 1,
                        customData: pageStr,
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY
                    }, "url('3ttlive-wb/img/mouse/mouse_pen.ico') 0 30, auto");
                break;
            case 'Pen'://画笔（实时同步）
                board.setTool("Pen",
                    {
                        stroke: stroke,
                        strokeWidth: options && options.strokeWidth ? options.strokeWidth : 1,
                        customData: pageStr,
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY
                    }, "url('3ttlive-wb/img/mouse/mouse_pen.ico') 0 30, auto");
                break;
            case 'Rect'://矩形
                var fill = options && options.fill ? options.fill : 'rgba(0,0,0,0)';
                board.setTool("Rect", {
                    stroke: options && options.stroke ? options.stroke : 'red',
                    strokeWidth: strokeWidth,
                    fill: fill,
                    customData: pageStr,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'Circle'://圆
                board.setTool("Circle", {
                    stroke: stroke,
                    strokeWidth: strokeWidth,
                    fill: 'rgba(0,0,0,0)',
                    customData: pageStr,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'Line'://直线
                board.setTool("Line", {
                    stroke: stroke,
                    strokeWidth: strokeWidth,
                    customData: pageStr,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'Arrow'://箭头
                board.setTool("Arrow",
                    {
                        stroke: stroke,
                        strokeWidth: strokeWidth,
                        fill: 'rgba(0,0,0,0)',
                        customData: pageStr,
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY
                    });
                break;
            case 'Dashed'://虚线
                board.setTool("Line",
                    {
                        stroke: stroke,
                        strokeWidth: strokeWidth,
                        strokeDashArray: [5, 5],
                        customData: pageStr,
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY
                    });
                break;
            case 'IText'://文字
                var fill = options && options.fill ? options.fill : 'red';
                board.setTool("IText",
                    {
                        fill: fill,
                        fontSize: fontSize,
                        customData: pageStr,
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY,
                        originX: 'left',
                        originY: 'top'
                    });
                break;
            case 'Eraser'://橡皮
                board.setTool("Eraser",
                    {
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY
                    }, "url('3ttlive-wb/img/mouse/mouse_eraser.ico') 9 23, crosshair");
                break;
            case 'SingleEraser'://单击橡皮
                board.setTool("Eraser",
                    {
                        customOffsetX: customOffsetX,
                        customOffsetY: customOffsetY
                    }, "url('3ttlive-wb/img/mouse/mouse_eraser.ico') 9 23, crosshair");
                break;
            case 'MultiEraser'://范围橡皮
                board.setTool("MultiEraser", {fill: 'rgba(65,105,225,0.3)'});
                break;
            case 'Pointer'://激光笔
                board.setTool("Pointer", {
                    stroke: stroke,
                    height: 15,
                    width: 15,
                    customData: pageStr,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'Default'://取消绘画
                board.setTool("Default");
                board.tool = {
                    toolType: '',
                    options: {}
                }
                break;
            case 'Edit'://编辑模式
                board.setTool("Edit");
                break;
            case 'save2img'://保存为图片
                board.saveAsImage();
                break;
            case 'clearAll'://清除
                board.clearAll(true, false, slideId === 0 ? '0' : slideId + '_' + currentPage)
                break;
            case 'clearAll2'://清除所有
                board.clearAll(true, true)
                break;
            case 'SingleArrow'://单向箭头
                board.setTool("Line", {
                    stroke: stroke,
                    strokeWidth: strokeWidth,
                    customData: currentPage,
                    arrowType: 1,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'DoubleArrow'://双向箭头
                board.setTool("Line", {
                    stroke: stroke,
                    strokeWidth: strokeWidth,
                    customData: currentPage,
                    arrowType: 2,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'Rhombus'://菱形
                board.setTool("Rhombus", {
                    stroke: stroke,
                    strokeWidth: strokeWidth,
                    fill: 'rgba(0,0,0,0)',
                    customData: currentPage,
                    customOffsetX: customOffsetX,
                    customOffsetY: customOffsetY
                });
                break;
            case 'imgCheck'://图片-对
                board.setTool("Image", {src: '3ttlive-wb/img/ic_check.png', width: 32, height: 32});
                break;
            case 'imgClose'://图片-错
                board.setTool("Image", {src: '3ttlive-wb/img/ic_close.png', width: 32, height: 32});
                break;
            case 'imgArrow'://图片-箭头
                board.setTool("Image", {src: '3ttlive-wb/img/ic_arrow.png', width: 32, height: 32});
                break;
            case 'undo'://撤销
                board.undo();
                break;
            case 'redo'://下一步
                board.redo();
                break;
            case 'MoveGroup'://拖动（多选）
                board.setTool("MoveGroup", {fill: 'rgba(65,105,225,0.3)'});
                break;
            case 'Edit'://拖动（多选）
                board.setTool("Edit");
                break;
            case 'recall': //激活唤起上一个画笔工具
                boardSetTool(board.tool.toolType, board.tool.options);//重设白板工具
                break;
        }
        if (toolType != '' && !(toolType == 'save2img' || toolType == 'clearAll' || toolType == 'clearAll2' || toolType == 'Default' || toolType == 'undo' || toolType == 'redo' || toolType == 'recall')) {
            board.tool.toolType = toolType;
            board.tool.options = options;
        }
        return true;
    } catch (error) {
        outsideCallError(error);
        return false;
    }
}


/**
 * 获取当前页和总页码
 * @return 课件当前页 3/22
 */
function getCurrentPage() {
    log && console.log('Call getCurrentPage: ', Array.prototype.slice.call(arguments))
    return currentPage + "/" + totalPage;
}
var getCurrentTotalPage = getCurrentPage;

/**
 * 获取课件白板详情
 */
function getInfo() {
    log && console.log('Call getInfo: ', Array.prototype.slice.call(arguments))
    return JSON.stringify({
        slideId: +slideId,
        slideType: slideType,
        currentPage: +currentPage,
        totalPage: +totalPage,
        pageCurrentStep: +pageCurrentStep,
        pageTotalStep: +pageTotalStep,
        isPlaying: !!isPlaying
    });
}

// ================================================================================================== //

/**
 * 设置控制按钮 disabled
 */
function disableContralBtn() {
    isLastOperate = true;
    contralBtnDisabled = true;
    setTimeout(function() {
        contralBtnDisabled = false;
    }, 100);
}

/**
 * 图片类型课件变动信令装箱
 * @param {number} scrollTop 滚动高度
 */
function sendImgChangeSql(scrollTop) {
    log && console.log('Func sendImgChangeSql: ', Array.prototype.slice.call(arguments))
    var slide = slidesMap[slideId];
    serverStatus = {
        slideId: slideId,
        page: currentPage,
        step: 0,
    };
    board.wsClient.sendMessage(JSON.stringify({
        data: {
            current: currentPage,
            slideId: slideId,
            imgSrc: slide ? slide.imgSrcData[currentPage - 1] : '',
            page: totalPage,
            scrollTop: scrollTop || 0,
            roomId: roomId
        },
        messageType: "document_content_broadcast_req"
    }), true,"docs_" + roomId);
}

/**
 * H5 类型课件变动信令装箱
 * @param {string} type 动作类型
 */
function sendPptControlSql(type) {
    log && console.log('Func sendPptControlSql: ', Array.prototype.slice.call(arguments));
    serverStatus = {
        slideId: slideId,
        page: currentPage,
        step: pageCurrentStep,
    };
    board.wsClient.sendMessage(JSON.stringify({
        data: {
            type: type,
            data: pageCurrentStep,
            current: currentPage,
            slideId: slideId,
            docSrc: slidesMap[slideId].htmlUrl,
            page: totalPage
        },
        messageType: "document_setControl"
    }), true,"docs_" + roomId);
}

/**
 * websocket 消息处理
 */
function handleBoardMessage(message) {
    if (
        message.eType != 17 ||
        !message.mChatTransMsg ||
        !/^docs_\d+$/.test(message.mChatTransMsg.sSeqID) ||
        !message.mChatTransMsg.sData
    ) {
        return ;
    }
    log && console.log('Func handleBoardMessage: ', Array.prototype.slice.call(arguments))
    isLastOperate = false;
    redressTimer && clearTimeout(redressTimer);
    var sData = JSON.parse(message.mChatTransMsg.sData);
    if (!boardInited) {
        initPageStr = +sData.data.current === 0 ? '0' : sData.data.slideId + '_' + sData.data.current;
    }
    var type = sData.data.type;
    var localPrevCurrentPage = currentPage;
    var localPrevPageCurrentStep = pageCurrentStep;
    currentPage = +sData.data.current;
    totalPage = +sData.data.page;
    slideId = +sData.data.slideId;
    serverStatus = {
        slideId: slideId,
        page: currentPage,
        step: +(sData.data.data || 0),
    };
    var newPageStr;
    switch (sData.messageType) {
        // 图片课件控制
        case 'document_content_broadcast_req':
            pageCurrentStep = 0;
            pageTotalStep = 0;
            slideType = 'img';
            cacheDocsMaps(sData.data);  // 加入课件缓存
            if (isMiniProgram) {
                pptIframe = $('<iframe id="ifr" style="position:absolute;" frameborder="0" scrolling="no" width="' + containerWidth + '" height="' + containerHeight + '" name="myframe" src="about:blank" allow="autoplay;encrypted-media"></iframe>')[0];
                $("#ifr").remove();
                $("#canvas").prepend(pptIframe);
            } else {
                pptIframe.src = 'about:blank';
            }
            // 控制 img 课件
            if (slideId !== 0) {
                if (preloadImg.src !== sData.data.imgSrc) {
                    changeSlideImg(sData.data.imgSrc, +sData.data.scrollTop)
                }
                newPageStr = slideId + "_" + currentPage;
            }
            // 切换到白板
            else {
                slideType = 'wb';
                if (board.getOptions().height != containerHeight) {
                    board.setOption({ width: containerWidth, height: containerHeight, write: true }); // 设置画布宽高
                }
                changeSlideImg('');
                newPageStr = '0';
            }
            break;
        // ppt 课件控制
        case 'document_setControl':
            pageCurrentStep = +sData.data.data;
            slideType = 'h5';
            cacheDocsMaps(sData.data); // 加课件档缓存
            // 打开课件
            if (type == -1) {
                changeSlideImg('');
                // h5 小游戏需要增加参数
                var docSrc_query = "?role=" + role + "&roomId=" + roomId + '&platform=' + platform;
                if (sData.data.docSrc.indexOf("?") !== -1) {
                    docSrc_query = docSrc_query.replace('?', '&');
                }
                var pptIframeSrc = sData.data.docSrc + docSrc_query;
                if (isMiniProgram) {
                    pptIframe = $('<iframe id="ifr" style="position:absolute;" frameborder="0" scrolling="no" width="' + containerWidth + '" height="' + containerHeight + '" name="myframe" src="' + pptIframeSrc + '" allow="autoplay;encrypted-media"></iframe>')[0];
                    $("#ifr").remove();
                    $("#canvas").prepend(pptIframe);
                } else {
                    pptIframe.src = pptIframeSrc;
                }
                pptIframe.setAttribute('width', containerWidth);
                pptIframe.setAttribute('height', containerHeight);
                board.setOption({width: containerWidth, height: containerHeight, write: true});   // 设置画布宽高
            }
            // 副播刷新进入
            else if (sData.data.docSrc !== '' && pptIframe.getAttribute('src') === 'about:blank') {
                var docSrc_query = "?role=" + role + "&roomId=" + roomId + '&platform=' + platform;
                if (sData.data.docSrc.indexOf("?") !== -1) {
                    docSrc_query = docSrc_query.replace('?', '&');
                }
                var pptIframeSrc = sData.data.docSrc + docSrc_query;
                if (isMiniProgram) {
                    pptIframe = $('<iframe id="ifr" style="position:absolute;" frameborder="0" scrolling="no" width="' + containerWidth + '" height="' + containerHeight + '" name="myframe" src="' + pptIframeSrc + '" allow="autoplay;encrypted-media"></iframe>')[0];
                    $("#ifr").remove();
                    $("#canvas").prepend(pptIframe);
                } else {
                    pptIframe.src = pptIframeSrc;
                }
            }
            // 上一页、下一页、上步、下步、跳转
            else {
                // 上一页、下一页、上步、下步、调转页
                if (!(type === 5 && currentPage === localPrevCurrentPage && pageCurrentStep === localPrevPageCurrentStep)) {
                    setControl(type, currentPage, pageCurrentStep);
                }
            }
            newPageStr = sData.data.slideId + "_" + sData.data.current;
            break;
        default:
            break;
    }
    newPageStr && changePage(newPageStr);
    // 同步幻灯片滚动
    if (sData.data.scrollTop || sData.data.scrollTop === 0) {
        changeScrollTop(sData.data.scrollTop);
    }
}

/**
 * 加入课件缓存
 * @param {object} data 课件信息
 */
function cacheDocsMaps(data) {
    if (typeof(slidesMap[data.slideId]) === 'undefined') {
        var docObj = {};
        docObj.id = +data.slideId;
        docObj.page = +data.page;
        if (slideType === 'img') {
            docObj.imgSrcData = Array();
            if (/-\d.(png|jpe?g)$/i.test(data.imgSrc)) {
                var baseImgSrc = data.imgSrc.substring(0, data.imgSrc.lastIndexOf("-"));
                var imgType = data.imgSrc.substring(data.imgSrc.lastIndexOf("."));
                for (var i = 0; i < data.page; i++) {
                    docObj.imgSrcData.push(baseImgSrc + "-" + i + imgType);
                }
            } else {
                docObj.imgSrcData.push(data.imgSrc);
            }
        } else {
            docObj.htmlUrl = data.docSrc;
        }
        slidesMap[slideId] = docObj;
    }
}

/**
 * 切换图片课件
 */
function changeDocumentContent() {
    log && console.log('Func changeDocumentContent: ', Array.prototype.slice.call(arguments))
    var imgSrc = slidesMap[slideId].imgSrcData[currentPage - 1];
    changeSlideImg(imgSrc, 0);
    changePage(slideId + "_" + currentPage);
    changeScrollTop(0);
    sendImgChangeSql();
}

/**
 * 切换 ppt 课件内容
 * @param {number} type
 */
function changeDocumentH5Content(type) {
    log && console.log('Func changeDocumentH5Content: ', Array.prototype.slice.call(arguments))
    switch (type) {
        // 上一页 
        case 1:
        // 下一页 
        case 2:
            setControl(type);
            sendPptControlSql(type);
            changePage(slideId + "_" + currentPage);
            break;
        // 上一步
        case 3:
        // 下一步
        case 4:
            setControl(type);
            sendPptControlSql(type);
            break;
        // 跳转到某页，data为对应页码
        case 5:
            setControl(type);
            sendPptControlSql(type);
            changePage(slideId + "_" + currentPage);
            break;
        // 打开课件
        case -1:
            changeSlideImg('');
            var pptH5Url = slidesMap[slideId].htmlUrl;
            // h5 小游戏需要使用的两个参数
            var docSrc_query = "?role=" + role + "&roomId=" + roomId + '&platform=' + platform;
            if (pptH5Url.indexOf("?") !== -1) {
                docSrc_query = docSrc_query.replace('?', '&');
            }
            var pptIframeSrc = pptH5Url + docSrc_query + '&platform=' + platform;
            if (isMiniProgram) {
                $(pptIframe).remove();
                pptIframe = $('<iframe id="ifr" style="position:absolute;" frameborder="0" scrolling="no" width="' + containerWidth + '" height="' + containerHeight + '" name="myframe" src="' + pptIframeSrc + '" allow="autoplay;encrypted-media"></iframe>')[0];
                $("#canvas").prepend(pptIframe);
            } else {
                pptIframe.src = pptIframeSrc;
            }
            sendPptControlSql(type);
            changePage(slideId + "_" + currentPage);
            break;
        default:
            break;
    }
}

/**
 * ppt 控制操作
 * @param {number} type 操作类型
 */
function setControl(type) {
    log && console.log('Func setControl: ', Array.prototype.slice.call(arguments))
    switch (type) {
        // 上一页
        case 1:
            pptIframe.contentWindow.postMessage(JSON.stringify({
                name: 'prevPage',
            }), slideOrigin)
            break;
        // 下一页
        case 2:
            pptIframe.contentWindow.postMessage(JSON.stringify({
                name: 'nextPage',
            }), slideOrigin);
            break;
        // 上一步
        case 3:
            pptIframe.contentWindow.postMessage(JSON.stringify({
                name: 'prevStep',
            }), slideOrigin)
            break;
        // 下一步
        case 4:
            pptIframe.contentWindow.postMessage(JSON.stringify({
                name: 'nextStep',
            }), slideOrigin)
            break;
        // 跳转指定页-步
        case 5:
            pptIframe.contentWindow.postMessage(JSON.stringify({
                name: 'jump',
                page: currentPage,
                step: pageCurrentStep
            }), slideOrigin)
            break;
        default:
            break;
    }
}

/**
 * 与 pptH5 通信：接受 pptH5 发来的消息
 */
window.addEventListener('message', function (res) {
    if (pptIframe.src.indexOf(res.origin) === -1) {
        return ;
    }

    var data = JSON.parse(res.data);
    switch (data.name) {
        case 'load':
            isPptReady = false;
            slideOrigin = res.origin;
            pptIframe.contentWindow.postMessage('init', slideOrigin);
            break;
        case 'ready':
            log && console.log('ppt ready');
            isPptReady = true;
            if (slideType === 'h5' && (currentPage > 1 || pageCurrentStep > 0)) {
                setControl(5);
            }
            break;
        case 'error':
            nativeCallback('onError', {
                type: 'PPT_' + (data.type || 'UNEXPECTED_ERROR'),
                message: data.message
            });
            break;
        case 'change':
            if (isPlaying) {
                return ;
            }
            var localPrevCurrentPage = currentPage;
            var localPrevPageCurrentStep = pageCurrentStep;
            currentPage = +data.page;
            pageCurrentStep = +data.step;
            pageTotalStep = +data.totalStep;
            slidesMap[slideId][data.page] = +data.step;
            log && console.log('ppt onChange: ', {
                currentPage: data.page,
                pageCurrentStep: data.step,
            });
            changePage(slideId + '_' + data.page);
            if (localPrevCurrentPage !== currentPage || localPrevPageCurrentStep !== pageCurrentStep) {
                log && console.log('ppt onChange localPrevCurrentPage !== page: ', prevPage);
                // 最后操作 ppt 的人要发送页码异常变更的同步信令
                if (isLastOperate) {
                    redressTimer && clearTimeout(redressTimer);
                    (function redress(delay) {
                        log && console.log('call redress: ', delay);
                        redressTimer = setTimeout(function() {
                            log && console.log('run redress: ', delay);
                            if (isPlaying) {
                                return redress(500);
                            }
                            redressTimer = null;
                            sendPptControlSql(5);
                        }, delay);
                    })(300);
                } else {
                    redressTimer && clearTimeout(redressTimer);
                    (function redress(delay) {
                        log && console.log('callee redress: ', delay);
                        redressTimer = setTimeout(function() {
                            if (isPlaying) {
                                return redress(500);
                            }
                            log && console.log('runee redress: ', delay);
                            redressTimer = null;
                            pageCurrentStep = serverStatus.step;
                            currentPage = serverStatus.page;
                            setControl(5);
                        }, delay);
                    })(5000);
                }
            } else {
                redressTimer && clearTimeout(redressTimer);
            }
            break; 
        case 'playingStart':
            isPlaying = true;
            break;
        case 'playingEnd':
            isPlaying = false;
            break;
        default:
            break;
    }
})

/**
 * 设置滚动条百分比
 * @param {number} percent 百分比
 */
function changeScrollTop(percent) {
    log && console.log('Func changeScrollTop: ', Array.prototype.slice.call(arguments))
    var scrollTop = Math.round(board.getOptions().height) - Math.round(containerHeight);
    scrollTop = scrollTop * percent / 100;
    $(".container").scrollTop(scrollTop);
}

/**
 * 更改 img 课件的 src
 * @param {string} src 新 img 的 src
 * @param {number?} scrollTop 滚动百分比
 */
function changeSlideImg(src, scrollTop) {
    if (src) {
        preloadImg.src = src;
        preloadImg.onload = function () {
            var width = containerWidth;
            var height = preloadImg.height * width / preloadImg.width;
            if (board.getOptions().height != height) {
                board.setOption({ width: width, height: height, write: true }); // 设置画布宽高
            }
            typeof scrollTop === 'number' && changeScrollTop(scrollTop);
            preloadImg.onload = null;
        };
        typeof scrollTop === 'number' && changeScrollTop(scrollTop);
        $("#canvas").css('background-image', "url('" + src + "')");
    } else {
        preloadImg.src = '';
        $("#canvas").css('background-image', '');
    }
}

/**
 * 移动触屏滑动
 */
function Slider() {
    // 判断设备是否支持 touch 事件
    this.touch = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
    this.slider = $(".container")[0],

    // 事件
    this.events = {
        index: 0,     // 显示元素的索引
        slider: this.slider,     // this 为 slider 对象
        handleEvent: function (event) {
            var self = this;     // this 指 events 对象
            if (event.type == 'touchstart') {
                self.start(event);
            } else if (event.type == 'touchmove') {
                self.move(event);
            } else if (event.type == 'touchend') {
                self.end(event);
            }
        },
        // 滑动开始
        start: function (event) {
            var touch = event.targetTouches[0];     // touches 数组对象获得屏幕上所有的 touch，取第一个 touch
            startPos = { x: touch.pageX, y: touch.pageY, time: +new Date };    // 取第一个 touch 的坐标值
            isScrolling = 0;   // 这个参数判断是垂直滚动还是水平滚动
            this.slider.addEventListener('touchmove', this, false);
            this.slider.addEventListener('touchend', this, false);
        },
        //移动
        move: function (event) {
            // 当屏幕有多个 touch 或者页面被缩放过，就不执行 move 操作
            if (event.targetTouches.length > 1 || event.scale && event.scale !== 1) return;
            var touch = event.targetTouches[0];
            endPos = {x: touch.pageX - startPos.x, y: touch.pageY - startPos.y};
            endPosY = touch.pageY;
            isScrolling = Math.abs(endPos.x) < Math.abs(endPos.y) ? 1 : 0;    // isScrolling 为 1 时，表示纵向滑动，0 为横向滑动
            if (isScrolling === 0) {
                event.preventDefault();      // 阻止触摸事件的默认行为，即阻止滚屏
            }
            // todo 没有滚动动画
        },
        // 滑动释放
        end: function (event) {
            var duration = +new Date - startPos.time;    //滑 动的持续时间
            if (isScrolling === 1) {    // 当为纵向滚动时
                endPos.y = -endPos.y;
                var scrollTop = endPos.y + $(".container").scrollTop();
                if (scrollTop < 0) {
                    scrollTop = 0;
                }
                if ($(".container").scrollTop() != scrollTop && (board.tool.toolType == '' || board.tool.toolType == 'Default')) {
                    $(".container").scrollTop(scrollTop);
                    if (role === 1) {
                        sendImgChangeSql([slidesMap[slideId].imgSrcData[currentPage - 1], currentPage, totalPage, slideId, 0, scrollTop]);
                    }
                }
            }
            // 解绑事件
            this.slider.removeEventListener('touchmove', this, false);
            this.slider.removeEventListener('touchend', this, false);
        }
    },

    // 初始化
    this.init = function () {
        var self = this;     // this 指 slider 对象
        if (!!self.touch) self.slider.addEventListener('touchstart', self.events, false);    // addEventListener 第二个参数可以传一个对象，会调用该对象的 handleEvent 属性
    }
};


var objCache = {};
var board = null;
var boardInited = false;    // 白板对象初始化是否完成
var originBoardWidth = 960;
var containerWidth = 960;
var containerHeight = 540;
var wsUrl;

// ipLocation 之后初始化白板
function initWhiteBoard(wsUrl) {
    log && console.log('Func initWhiteBoard: ', Array.prototype.slice.call(arguments))
    if (board) {
        return ;
    }
    var size = getNewContainerSize(toRotate);
    containerWidth = size.width;
    containerHeight = size.height;
    $('.container').width(containerWidth);
    $('.container').height(containerHeight);
    pptIframe.setAttribute('width', containerWidth);
    pptIframe.setAttribute('height', containerHeight);

    board = new WhiteBoard({
        uid: userId,
        divId: "canvas",
        role: role,
        roomId: roomId,
        appId: appId,
        syncType: 2,
        username: role === 1 ? '' : userName
    }, {width: containerWidth, height: containerHeight, wsUrl: wsUrl});
    var zoomRatio = containerWidth / originBoardWidth || 0.01;
    board.changeZoom([0, 0], zoomRatio);    // 缩放画布上图形显示比例
    board.tool = {
        toolType: '',
        options: {}
    }

    board.on('inited', function (ws) {
        sourceWs = ws;
        log && console.log("wb inited")
        board.setTool('Default');
        // 获取当前页画笔数据
        fetchPaintingSignalings([initPageStr]);
        // 如果当前页不是白板，则延时 1s 预取附近页数据
        if (initPageStr !== '0') {
            setTimeout(function() {
                var adjacentPages = getAdjacentPages(initPageStr);
                fetchPaintingSignalings(['0'].concat(adjacentPages));
            }, 1000);
        }

        boardInited = true;
        $("#canvas").show();
        nativeCallback('onReady', {
            slideId: +slideId,                   // 课件id
            totalPage: +totalPage,               // 总页码
            currentPage: +currentPage,           // 当前页
            pageCurrentStep: +pageCurrentStep    // 当前页当前步
        });

        // 注册滚动回调
        if (role === 1) {
            $(".container").on("scroll", throttle(function (e) {
                if (slideType !== 'img') {
                    return ;
                }
                var scrollTop = e && e.target.scrollTop;
                var scrollTopPercent = scrollTop / (Math.round(board.getOptions().height) - Math.round(containerHeight)) * 100;
                sendImgChangeSql(scrollTopPercent);
            }, 100, 1000))
        }
        var slider = new Slider();
        slider.init();
    });

    board.on('wsMessage', handleBoardMessage);

    board.on('wsOpen', function (ws) {
        log && console.log("ws open")
    });

    // 文字溢出白板时自动换行
    // board.on('objectAdded', function (obj) {
    //     var json = obj.toJSON();
    //     if (json.type === 'IText') {
    //         obj.on('textChanged', function () {
    //             var json = obj.toJSON();
    //             if (json.style.originX === "center") {
    //                 if (json.style.width / 2 + json.style.left > 960 || json.style.width / 2 - json.style.left > 0) {
    //                     var str = json.style.text;
    //                     var str1 = str.substring(0, str.length - 1);
    //                     var str2 = str.substring(str.length - 1, str.length);
    //                     obj.updateOptions({text: str1 + '\n' + str2}, false);
    //                     obj.setSelectionStartEnd(str.length + 1, str.length + 1);
    //                 }
    //             } else if (json.style.originX === "left") {
    //                 if (json.style.width + json.style.left > 960) {
    //                     var str = json.style.text;
    //                     var str1 = str.substring(0, str.length - 1);
    //                     var str2 = str.substring(str.length - 1, str.length);
    //                     obj.updateOptions({text: str1 + '\n' + str2}, false);
    //                     obj.setSelectionStartEnd(str.length + 1, str.length + 1);
    //                 }
    //             }
    //         })
    //     }
    // });
}

var prevSlideId = 0;
var prevCurrentPage = 0;
var prevPageCurrentStep = 0;

/**
 * 改变白板上课件页码并调用 onChange 回调
 * @param {string} newPageStr 新页码 {slideId}_{page}
 */
var changePage = throttle(function changePage(newPageStr) {
    log && console.log('Func changePage: ', Array.prototype.slice.call(arguments));
    if (boardInited && (prevCurrentPage !== currentPage || prevPageCurrentStep !== pageCurrentStep || prevSlideId !== slideId)) {
        prevCurrentPage = currentPage;
        prevPageCurrentStep = pageCurrentStep;
        prevSlideId = slideId;
        nativeCallback('onChange', {
            slideId: +slideId,
            totalPage: +totalPage,
            currentPage: +currentPage,
            pageCurrentStep: +pageCurrentStep,
        });
    }
    if (pageStr === newPageStr) {
        return;
    }
    objCache[pageStr] = [];
    var objMap = board.getObjects();
    var objMapKeys = Object.keys(objMap);
    objMapKeys.forEach(function(key) {
      var objPageStr = objMap[key].toJSON().customData;
        objPageStr === pageStr && objCache[pageStr].push(objMap[key]);
    });
    
    board.clearAll(false);
    pageStr = newPageStr;
    rePaint(pageStr);
    boardSetTool(board.tool.toolType, board.tool.options); // 重设白板工具
    changeScrollTop(0); // 重置滚动条

    if (isMobile) {
        if (slideId) {
            $('.whiteboard-tag').hide();
        } else {
            $('.whiteboard-tag').show();
        }
    }
}, 100, 1000);


/**
 * 重绘指定页码的画笔记录
 * @param {string} newPageStr 页码 {slideId}_{page}
 */
function rePaint(newPageStr) {
    // 从缓存中获取 newPageStr 的画笔记录
    if (Array.isArray(objCache[newPageStr])) {
      objCache[newPageStr].forEach(function(item) {
        // 缓存中存储的画笔信令（从接口获取的）
        if (typeof item === 'string') {
            board.wsClient.messageHandler({ data: item });
        }
        // 缓存中存储的画笔对象（从白板摘下的）
        else {
            item.addToCanvas(false);
        }
      });
    }
    // 缓存没有记录 newPageStr 的画笔记录，则向服务器请求
    else {
        fetchPaintingSignalings([newPageStr]);
    }
    var adjacentPages = getAdjacentPages(newPageStr);
    // 请求相邻页码的画笔记录
    fetchPaintingSignalings(adjacentPages);
}

/**
 * 获取指定页码的画笔记录
 * @param {string} page 页码  {slideId}_{page}
 */
function fetchPaintingSignalings(page) {
    var fetchPages = page.filter(function(item) {
        return !objCache[item] || item === '0';
    });
    if (fetchPages.length === 0) {
        return {};
    }
    for (var i = 0; i < fetchPages.lengh; i++) {
        objCache[fetchPages[i]] = 'fetching';
    }
    $.ajax({
        type: 'get',
        url: apiDomain + '/server/get-brush',
        cache: false,
        data: {
            roomId: roomId,
            docPage: fetchPages.join()
        },
        dataType: 'jsonp',
        success: function (res) {
            log && console.log('getPaintingSignalings.res');
            if (res.code !== 0) {
                log && console.error('白板画笔数据获取失败（' + res.message + '）:', res);
                return {};
            } else {
                var paintingSignalings = res.data;
                var pageStrs = Object.keys(paintingSignalings);
                pageStrs.forEach(function(pageStrItem) {
                  if (pageStrItem === pageStr && !objCache[pageStr]) {
                    paintingSignalings[pageStrItem].forEach(function (item) {
                      board.wsClient.messageHandler({ data: item });
                    });
                  }
                })
                objCache = Object.assign(objCache, paintingSignalings);
                return res.data;
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            log && console.error('api fetch Persistent Signalings failed: ', XMLHttpRequest, textStatus, errorThrown);
            return {};
        }
    });

}

/**
 * 获取相邻页码
 * @param {string} pageStr 页码 {slideId}_{page}
 * @returns {string[]} 相邻页码
 */
function getAdjacentPages(pageStr) {
    if (pageStr === '0') {
        return [];
    } else {
        var page = +pageStr.substr(-1);
        var slideId = pageStr.slice(0, -2);
        var block = [slideId + "_" + (page + 1)];
        if (page > 1) {
            block.unshift(slideId + "_" + (page - 1));
        }
        return block;
    }
}

/**
 * 原生应用回调
 * @param {strinng} name 方法名字 onError onChange onReady
 * @param {string} param 方法参数
 */
function nativeCallback(name, data, withoutLog) {
    log && console.log('Callback ', name, data);
    var dataJson = JSON.stringify(data);
    if (window[name]) {
        window[name](dataJson);
    }
    if (isIos) {
        window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers[name] &&
        window.webkit.messageHandlers[name].postMessage &&
        window.webkit.messageHandlers[name].postMessage(dataJson);
    }
    if (isAndroid) {
        window.android &&
        window.android[name] &&
        window.android[name](dataJson);
    }
    if (isWindows) {
        window.CefExtension &&
        window.CefExtension[name] &&
        window.CefExtension[name](dataJson)
    }
    if (name === 'onChange') {
        isWindows && winClientSyncLoad();
        $("#slideId").val(slideId ? slideId : '');
        $("#currentPage").val(currentPage);
        $("#totalPage").val(totalPage);
        $("#pageCurrentStep").val(pageCurrentStep);
        $("#docTotalPage").val(totalPage);      // 兼容老版本 pc
        $("#docCurrentPage").val(currentPage);  // 兼容老版本 pc
        // 适配小程序
        var cEvent = document.createEvent('CustomEvent');
        cEvent.initCustomEvent('cOnChange', true, true, {
            slideType: slideType,
            page: currentPage,
            totalPage: totalPage,
        });
        document.dispatchEvent(cEvent);
    } else if (name === 'onError' && !withoutLog) {
        reportLog({
            type: data.type,
            message: data.message
        });
    }
}

/**
 * 运行主程序
 * @param {number} retry 重试次数
 */
function run(retry) {
    retry = retry || 0;
    log && retry && console.warn("Fun run - ipLocation retry ", retry);
    var reqUrl = ipLocationUrl + "?appId=" + appId + "&roomId=" + roomId + "&ip=&userId=" + userId;
    log && console.log("Fun run - ipLocationUrl: ", reqUrl);
    $.ajax({
        type: "get",
        url: reqUrl,
        cache: false,
        dataType: "jsonp",
        success: function (data) {
            log && console.log("ipLocation.res", data.data)
            try {
                if (data.code === 0) {
                    if (location.protocol == 'http:') {
                        wsUrl = "ws://" + data.data['roomServer'].host + ":" + data.data['roomServer'].port;
                    } else {
                        wsUrl = "wss://" + data.data['roomServer-wss'].host + ":" + data.data['roomServer-wss'].port;
                    }
                    wsUrl = "wss://" + data.data['roomServer-wss'].host + ":" + data.data['roomServer-wss'].port;
                    initWhiteBoard(wsUrl);
                } else {
                    throw(data);
                }
            } catch (error) {
                log && console.warn('iploaction request catch: ', error);
                if (retry < 3) {
                    setTimeout(function retryRun() {
                        run(++retry);
                    }, retry * 2000);
                }
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            textStatus = textStatus || '';
            errorThrown = errorThrown || '';
            log && console.warn('iploaction request error: ', XMLHttpRequest);
            if (retry < 3) {
                run(++retry);
            } else {
                nativeCallback('onError', {
                    type: 'API_REQUEST_ERROR',
                    message: 'iplocation failed: ' + textStatus + '; ' + XMLHttpRequest.responseText + '; ' + errorThrown
                });
            }
        }
    });
}

$(document).ready(function handleReady() {
    log && console.log("--- ready ---");
    if (!isMobile) {
        $('.whiteboard-tag').hide();
    }
    window.addEventListener('resize', throttle(resizeAdapt, 100), false);
    run();
});

function outsideCallError(error) {
    log && console.error('Outside calls error: ', error)
    nativeCallback('onError', {
        type: 'OUTSIDE_CALL_ERROR',
        message: error.stack
    });
}

window.onerror = function (msg, url, lineNo, columnNo, error) {
    var message = [
        'Message: ' + msg,
        'URL: ' + url,
        'Line: ' + lineNo,
        'Column: ' + columnNo,
        'Error object: ' + JSON.stringify(error),
        'Error stack:' + error && error.stack || ''
    ].join(' - ');
    if (isIos && message.indexOf("TypeError: null is not an object (evaluating 'this._cacheContext.setTransform')") !== -1) {
        return false;
    }
    nativeCallback('onError', {
        type: 'UNEXPECTED_ERROR',
        message: message
    });
    return false;
};

// ==================== utils ==================================
function parseURL(url) {
    log && console.log('Func parseURL: ', Array.prototype.slice.call(arguments));
    var a = document.createElement('a');
    a.href = url;
    return {
        source: url,
        origin: a.origin,
        protocol: a.protocol,
        hostname: a.hostname,
        host: a.host,
        port: a.port,
        pathname: a.pathname,
        params: (function () {
            var ret = {},
            seg = a.search.slice(1).split('&'),
            len = seg.length, i = 0, s;
            for (; i < len; i++) {
                if (!seg[i]) {
                    continue;
                }
                s = seg[i].split('=');
                ret[s[0].toLowerCase()] = decodeURIComponent(s[1]);
            }
            return ret;
        })(),
        // query: a.search,
        // file: (/\/([^\/?#]+)$/i.exec(a.pathname) || [, ''])[1],
        // hash: a.hash.replace('#', ''),
        // relative: (/tps?:\/\/[^\/]+(.+)/.exec(a.href) || [, ''])[1],
        // segments: a.pathname.slice(1).split('/')
    };
}

function getNewContainerSize(rotate) {
    var containerWidth, containerHeight;
    if (rotate) {
        var windowWidth = documentBody.clientHeight || 960;
        var windowHeight = documentBody.clientWidth || 540;
        var containerHeightBaseWidth = windowWidth / 16 * 9;

        if (containerHeightBaseWidth > windowHeight) {
            containerHeight = windowHeight;
            containerWidth = Math.ceil(containerHeight / 9 * 16);
        } else {
            containerWidth = windowWidth;
            containerHeight = Math.ceil(containerWidth / 16 * 9);
        }
        $('.container').css('transform', 'rotate(90deg)');
    }
    // 正常展示
    else {
        var windowWidth = documentBody.clientWidth || 960;
        var windowHeight = documentBody.clientHeight || 540;
        var containerHeightBaseWidth = windowWidth / 16 * 9;

        if (containerHeightBaseWidth > windowHeight) {
            containerHeight = windowHeight;
            containerWidth = Math.ceil(containerHeight / 9 * 16);
        } else {
            containerWidth = windowWidth;
            containerHeight = Math.ceil(containerWidth / 16 * 9);
        }
    }
    return {
        width: containerWidth,
        height: containerHeight
    };
}

function throttle(func, wait, mustRun) {
    var timeout,
        startTime = new Date();
    return function () {
        var context = this,
            args = Array.prototype.slice.call(arguments),
            curTime = new Date();
        clearTimeout(timeout);
        // 如果达到了规定的触发时间间隔，触发 handler
        if (curTime - startTime >= mustRun) {
            startTime = curTime;
            func.apply(context, args);
            // 没达到触发间隔，重新设定定时器
        } else {
            timeout = setTimeout(func.bind(context, args[0]), wait);
        }
    };
}

function winClientSyncLoad() {
    log && console.log('winClientSyncLoad', syncIframe && syncIframe.src);
    if (syncIframe) {
        syncIframe.src = apiDomain + '?count=' + ++syncIframeCount;
    } else {
        syncIframe = document.createElement('iframe');
        syncIframe.onload = function() {
            log && console.log('winClientSyncLoad onload', syncIframe.src);
        }
        syncIframe.onerror = function(msg, url, lineNo, columnNo, error) {
            var message = [
                'Message: ' + msg,
                'URL: ' + url,
                'Line: ' + lineNo,
                'Column: ' + columnNo,
                'Error object: ' + JSON.stringify(error),
                'Error stack: ' + error && error.stack || '',
            ].join(' - ');
            log && console.log('winClientSyncLoad onerror', syncIframe.src, message);
            nativeCallback('onError', {
                type: 'IFRAME_ON_ERROR',
                message: message
            })
        }
        syncIframe.name = 'tmp_frame';
        syncIframe.src = apiDomain + '?count=0';
        syncIframe.style.display = 'none';
        documentBody.appendChild(syncIframe);
    }
}

function reportLog(params, retry) {
    retry = retry || 0;
    var env = apiDomain.indexOf('devim') !== -1 ? 'dev' : apiDomain.indexOf('preim') !== -1 ? 'pre' : 'prod';
    var postData = {
        type: params.type,
        env: env,
        appId: appId,
        classId: roomId,
        userId: userId,
        slideId: slideId,
        role: role,
        version: version,
        platform: platform,
        userAgent: ua,
        message: params.message,
        extend: JSON.stringify({
            apiDomain: apiDomain,
            ipLocationUrl: ipLocationUrl,
            wsUrl: wsUrl,
            slideId: slideId,
            slideType: slideType,
            currentPage: currentPage,
            totalPage: totalPage,
            pageCurrentStep: pageCurrentStep,
            pageTotalStep: pageTotalStep,
            serverStatus: serverStatus,
            isPlaying: isPlaying,
            isPptReady: isPptReady,
            isBoardReady: boardInited,
            isLastOperate: isLastOperate,
            contralBtnDisabled: contralBtnDisabled,
            redressTimer: redressTimer,
        })
    };
    $.ajax({
        type: "post",
        url: 'https://devapi3tclass.3ttech.cn/course/error-log',
        cache: false,
        data: postData,
        success: function (data) {
            log && console.log("reportlog.res", data)
            if (data.code !== 0) {
                if (retry < 3) {
                    setTimeout(function retryRun() {
                        reportLog(params, ++retry);
                    }, retry * 2000);
                } else {
                    nativeCallback('onError', {
                        type: 'API_REQUEST_ERROR',
                        message: 'repoort log failed: ' + JSON.stringify(data)
                    }, true);
                }
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            textStatus = textStatus || '';
            errorThrown = errorThrown || '';
            log && console.warn('reportlog request error: ', XMLHttpRequest);
            if (retry < 3) {
                reportLog(++retry);
            } else {
                nativeCallback('onError', {
                    type: 'API_REQUEST_ERROR',
                    message: 'repoort log failed: ' + textStatus + '; ' + XMLHttpRequest.responseText + '; ' + errorThrown
                }, true);
            }
        }
    });
}