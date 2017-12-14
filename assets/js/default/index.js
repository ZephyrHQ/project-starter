"use strict";

import $ from 'jquery';

$(() => {
    if (navigator.geolocation) {
        // L'API est disponible
        navigator.geolocation.getCurrentPosition(
            (position) => {
                console.log(position);
            },
            (error) => {
                console.error(error);
            }
        );
    } else {
        // Pas de support, proposer une alternative ?
        console.log('navigateur obsolète : geoloc indisponible');
    }
});
