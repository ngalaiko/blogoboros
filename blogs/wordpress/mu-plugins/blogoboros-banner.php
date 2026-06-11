<?php
/**
 * Plugin Name: Blogoboros Banner
 * Description: The moved-banner. Added February 2013, when this blog left for Jekyll. The blog has since returned. The banner stays, because the banner is correct: the blog HAS moved. It is always moving. That is all it does.
 * Author: Olav Ringdal
 */

add_action('wp_body_open', function () {
    echo '<div class="blogoboros-banner" data-moved-to="/2013/" '
        . 'style="background:#ffd54f;color:#222;padding:8px 16px;font-weight:bold;">'
        . 'This blog has moved. Read it at <a href="/2013/" style="color:#222;">its new home</a>.'
        . '</div>';
});
