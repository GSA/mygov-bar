<?php
$base = '../_includes/img/';
file_put_contents( $base . 'logo.base64', base64_encode( file_get_contents( $base . 'logo.png' ) ) );
