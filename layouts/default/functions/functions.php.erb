<?php

// Block direct access
if( ! defined( 'ABSPATH' ) ) exit;

// Set content_width
if ( ! isset( $content_width ) ) {
	$content_width = 640;
}

// Scaffold setup
if( ! function_exists( '<%= project_id %>_setup' ) ) :

	/**
	 * Sets up theme defaults and registers support for various WordPress features.
	 *
	 * Note that this function is hooked into the after_setup_theme hook, which
	 * runs before the init hook. The init hook is too late for some features, such
	 * as indicating support for post thumbnails.
	 */
	function <%= project_id %>_setup()
	{
		// Textdomain
		load_theme_textdomain( '<%= project_id %>', get_template_directory() . '/includes/languages' );
		load_child_theme_textdomain( '<%= project_id %>', get_stylesheet_directory() . '/includes/languages' );

		// Theme support
		add_theme_support( 'menus' );
		add_theme_support( 'post-thumbnails' );
		add_theme_support( 'automatic-feed-links' );
		add_theme_support( 'post-formats', array( /* 'aside', 'link', 'gallery', 'status', 'quote', 'image' */ ) );
		add_theme_support( 'html5', array( 'search-form', 'comment-form', 'comment-list' ) );

		// Editor
		add_editor_style( 'assets/css/editor-style.css' );

		// Menus
		register_nav_menus( array(
			'primary-menu'		=> __( 'Primary', '<%= project_id %>' ),
			'secondary-menu'	=> __( 'Secondary', '<%= project_id %>' ),
			'footer-menu'		=> __( 'Footer', '<%= project_id %>' )
		) );
	}

endif;

add_action( 'after_setup_theme', '<%= project_id %>_setup' );

/**
 * Init for theme child
 */
function <%= project_id %>_child_init() {
	do_action( '<%= project_id %>_child_init' );
}

add_action( 'after_setup_theme', '<%= project_id %>_child_init' );

/**
 * Enqueue scripts and styles.
 */
function <%= project_id %>_styles_scripts()
{
	// Styles
	add_action( 'wp_enqueue_scripts', 	'<%= project_id %>_register_styles' );
	add_action( 'wp_enqueue_scripts', 	'<%= project_id %>_enqueue_styles' );

	// Scripts
	add_action( 'wp_enqueue_scripts', 	'<%= project_id %>_register_scripts' );
	add_action( 'wp_enqueue_scripts', 	'<%= project_id %>_enqueue_scripts' );

	// Admin scripts
	add_action( 'admin_enqueue_scripts', 	'<%= project_id %>_register_admin_scripts' );
	add_action( 'admin_enqueue_scripts', 	'<%= project_id %>_enqueue_admin_scripts' );
}

add_action( 'init', '<%= project_id %>_styles_scripts' );

/**
 * Register styles.
 */
function <%= project_id %>_register_styles()
{
	// Theme
	wp_register_style( 'style', get_stylesheet_directory_uri() . '/style.css', '', '', 'screen' );
}

/**
 * Enqueue styles.
 */
function <%= project_id %>_enqueue_styles()
{
	wp_enqueue_style( 'style' );
}

/**
 * Register scripts
 */
function <%= project_id %>_register_scripts()
{
	// Theme
	wp_register_script( 'theme', get_stylesheet_directory_uri() . '/javascripts/theme.js', array( 'jquery' ), '', true );
}

/**
 * Enqueue scripts
 */
function <%= project_id %>_enqueue_scripts()
{
	wp_enqueue_script( 'theme' );

	if ( is_singular() && get_option( 'thread_comments' ) ) {
		wp_enqueue_script( 'comment-reply' );
	}
}

/**
 * Register admin scripts
 */
function <%= project_id %>_register_admin_scripts()
{
	// Admin
	wp_register_script( 'admin', get_stylesheet_directory_uri() . '/javascripts/admin.js', array( 'jquery' ), '', true );
}

/**
 * Enqueue admin scripts
 */
function <%= project_id %>_enqueue_admin_scripts()
{
	wp_enqueue_script( 'admin' );
}

/**
 * Allow automatic updates
 */
add_filter( 'automatic_updates_is_vcs_checkout', '__return_false' );

/**
 * All theme filters
 */
require get_template_directory() . '/includes/filters.php';

/**
 * All theme filters for admin
 */
require get_template_directory() . '/includes/filters-admin.php';

/**
 * Helper functions
 */
require get_template_directory() . '/includes/helpers.php';

