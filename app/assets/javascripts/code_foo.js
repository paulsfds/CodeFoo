$(function () {
    var $container = $('#container');

    $container.imagesLoaded(function () {
        $container.masonry({
            itemSelector:'.box',
            columnWidth: function(containerWidth) {
                return containerWidth / 5;
            }
        });
    });
});
