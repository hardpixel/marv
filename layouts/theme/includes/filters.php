<?php

// Block direct access
if( ! defined( 'ABSPATH' ) ) exit;

/**
 * Independent filters
 */
add_filter( 'widget_text', 'do_shortcode' );

/**
 * Body classes
 */
function <%= project_id %>_body_class( $classes )
{
    global $is_gecko, $is_IE, $is_opera, $is_safari, $is_chrome;

    if( $is_gecko )      	$classes[] = 'gecko';
    elseif( $is_opera )  	$classes[] = 'opera';
    elseif( $is_safari )	$classes[] = 'safari';
    elseif( $is_lynx )      $classes[] = 'lynx';
    elseif( $is_chrome )	$classes[] = 'chrome';
    elseif( $is_NS4 )       $classes[] = 'ns4';
    elseif( $is_IE )		$classes[] = 'ie';
    else               		$classes[] = 'unknown-browser';
    if( $is_iphone )        $classes[] = 'iphone';

    if( is_singular() ) {
    	global $post;
        foreach( ( get_the_category( $post->ID ) ) as $category ) {
            $classes[] = 'term-' . $category->category_nicename;
        }

        $classes[] = 'singular';
    }

    if( is_multi_author() ) {
		$classes[] = 'group-blog';
    }

	if( is_archive() || is_search() || is_home() ) {
		$classes[] = 'list-view';
    }

    return $classes;
}

add_filter( 'body_class', '<%= project_id %>_body_class' );

/**
 * Remove generator
 */
function <%= project_id %>_cleanup_head()
{
    remove_action('wp_head', 'feed_links', 2);
    remove_action('wp_head', 'feed_links_extra', 3);
    remove_action('wp_head', 'rsd_link');
    remove_action('wp_head', 'wlwmanifest_link');
    remove_action('wp_head', 'adjacent_posts_rel_link_wp_head', 10, 0);
    remove_action('wp_head', 'wp_generator');
    remove_action('wp_head', 'wp_shortlink_wp_head', 10, 0);
}

add_action( 'init', '<%= project_id %>_cleanup_head' );

/**
 * WP title
 */
function <%= project_id %>_wp_title( $title, $sep )
{
	global $paged, $page;

	if ( is_feed() ) {
		return $title;
    }

	// Add the site name.
	$title .= get_bloginfo( 'name' );

	// Add the site description for the home/front page.
	$site_description = get_bloginfo( 'description', 'display' );
	if ( $site_description && ( is_home() || is_front_page() ) ) {
		$title = "$title $sep $site_description";
    }

	// Add a page number if necessary.
	if ( $paged >= 2 ) {
		$title = "$title $sep " . sprintf( __( 'Page %s', '<%= project_id %>' ), max( $paged, $page ) );
    }

	return $title;
}

add_filter( 'wp_title', '<%= project_id %>_wp_title', 10, 2 );

/**
 * Nav object classes
 */
function <%= project_id %>_add_extra_menu_classes( $objects )
{
    $objects[1]->classes[] = 'first';
    $objects[count( $objects )]->classes[] = 'last';

    return $objects;
}

add_filter( 'wp_nav_menu_objects', 	'<%= project_id %>_add_extra_menu_classes' );

/**
 * Add favicon
 */
function <%= project_id %>_favicon()
{
    echo '<link rel="shortcut icon" href="' . get_stylesheet_directory_uri() . '/images/favicon.png" type="image/png">';
}

add_action( 'wp_head', '<%= project_id %>_favicon' );

