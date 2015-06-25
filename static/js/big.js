/*
big.js by Tom MacWright. See https://github.com/tmcw/big
Licensed CC0: https://github.com/tmcw/big/blob/gh-pages/LICENSE.md
*/
window.onload = function() {
    'use strict';
    var slides = Array.prototype.slice.call(document.getElementsByTagName('div'), 0),
        timerInterval,
        keyCodes = {
            PAGEUP: 33,
            PAGEDOWN: 34,
            LEFT: 37,
            UP: 38,
            RIGHT: 39,
            DOWN: 40
        };
    if (!slides) {
        return;
    }
    var big = {
        current: 0,
        forward: fwd,
        reverse: rev,
        go: go,
        length: slides.length
    };
    window.big = big;

    function resize() {
        var width = window.innerWidth,
            height = window.innerHeight,
            element = slides[big.current];


        // start the slide's text at "as tall as the window"
        element.style.fontSize = height + 'px';
        // now reduce it by 2 pixel-steps until it's small enough to fit
        for (var i = height - 2; element.offsetWidth > width || element.offsetHeight > height; i -= 2) {
            element.style.fontSize = i + 'px';
        }
        // vertically center the text by setting a margin-top equal to half the available empty space
        element.style.marginTop = ((height - element.offsetHeight) / 2) + 'px';
    }

    function go(pageNum) {
        big.current = pageNum;
        var slide = slides[pageNum],
            timeToNext = parseInt(slide.dataset.timeToNext || 0, 10);
        document.body.className = slide.dataset.bodyclass || '';
        slides.forEach(function(slide) {
            slide.style.display = 'none';
        });
        slide.style.display = 'inline';

        if (slide.firstChild && slide.firstChild.nodeName === 'IMG') {
            document.body.style.backgroundImage = 'url("' + slide.firstChild.src + '")';
            slide.firstChild.style.display = 'none';
            if ('classList' in slide) {
                slide.classList.add('imageText');
            }
        } else {
            document.body.style.backgroundImage = '';
            document.body.style.backgroundColor = slide.style.backgroundColor;
        }
        if (timerInterval !== undefined) {
            window.clearInterval(timerInterval);
        }
        if (timeToNext > 0){
            timerInterval = window.setTimeout(fwd, (timeToNext * 1000));
        }
        resize();
        if (window.location.hash !== pageNum) {
            window.location.hash = pageNum;
        }
        document.title = slide.textContent || slide.innerText;
    }

    document.onclick = function() {
        go(++big.current % (slides.length));
    };

    function fwd() {
        go(Math.min(slides.length - 1, ++big.current));
    }
    function rev() {
        go(Math.max(0, --big.current));
    }

    document.onkeydown = function(event) {
        if (~ [keyCodes.RIGHT, keyCodes.DOWN, keyCodes.PAGEDOWN].indexOf(event.which)) {
            fwd();
        }
        if (~ [keyCodes.LEFT, keyCodes.UP, keyCodes.PAGEUP].indexOf(event.which)) {
            rev();
        }
    };

    document.ontouchstart = function(startEvent) {
        var start = startEvent.changedTouches[0].pageX;
        document.ontouchend = function(endEvent) {
            var end = endEvent.changedTouches[0].pageX;
            if (end - start < 0) fwd();
            if (end - start > 0) rev();
        };
    };

    function parse_hash() {
        return Math.max(
            Math.min(
                slides.length - 1,
                parseInt(window.location.hash.substring(1), 10)
            ),
            0
        );
    }

    if (window.location.hash) {
        big.current = parse_hash() || big.current;
    }

    window.onhashchange = function() {
        var pageNum = parse_hash();
        if (pageNum !== big.current) {
            go(pageNum);
        }
    };

    window.onresize = resize;
    go(big.current);
}
