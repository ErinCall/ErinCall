(function () {
    $(".selectall").click(function() {
        // drawn from this SO answer: http://stackoverflow.com/a/987376/1308699
        var range, selection;

        if (document.body.createTextRange) { //ms
            range = document.body.createTextRange();
            range.moveToElementText(this);
            range.select();
        } else if (window.getSelection) { //all others
            selection = window.getSelection();
            range = document.createRange();
            range.selectNodeContents(this);
            selection.removeAllRanges();
            selection.addRange(range);
        }
    });
})();
