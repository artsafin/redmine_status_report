$(document).on('.tabs .tab[data-tab]').click((e) => {
    const clicked = $(e.target),
        tabsContainer = clicked.parents('.tabs[data-view-container]'),
        viewsContainer = $('#' + tabsContainer.data('viewContainer')),
        tabName = clicked.data('tab');

    if (!viewsContainer) {
        e.preventDefault();
        return;
    }

    tabsContainer.find('.tab').removeClass('selected');
    clicked.addClass('selected');

    viewsContainer.find('.tab').removeClass('selected');
    viewsContainer.find(`.tab.${tabName}`).addClass('selected');

    e.preventDefault();
});
