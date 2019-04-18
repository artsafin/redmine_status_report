$(document).on('click', '.tabs .tab[data-tab]', (e) => {
    e.preventDefault();

    const clicked = $(e.target),
        tabsContainer = clicked.parents('.tabs[data-view-container]'),
        viewsContainer = $('#' + tabsContainer.data('viewContainer')),
        tabName = clicked.data('tab');

    if (!viewsContainer) {
        return;
    }

    tabsContainer.find('.tab').removeClass('selected');
    clicked.addClass('selected');

    viewsContainer.find('.tab').removeClass('selected');
    viewsContainer.find(`.tab.${tabName}`).addClass('selected');
});
