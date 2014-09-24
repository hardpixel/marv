<?php
/**
 * Plugin Name: <%= project_config[:name] %>
 * Plugin URI: <%= project_config[:uri] %>
 * Description: <%= project_config[:description] %>
 * Version: <%= project_config[:version] %>
 * Author: <%= project_config[:author] %>
 * Author URI: <%= project_config[:author_uri] %>
 * License: <%= project_config[:license_name] %>
 * License URI: <%= project_config[:license_uri] %>
 */

// Block direct access
if( ! defined( 'ABSPATH' ) ) exit;


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
	wp_register_style( 'plugin', get_stylesheet_directory_uri() . '/plugin.css', '', '', 'screen' );
}

/**
 * Enqueue styles.
 */
function <%= project_id %>_enqueue_styles()
{
	wp_enqueue_style( 'plugin' );
}

/**
 * Register scripts
 */
function <%= project_id %>_register_scripts()
{
	// Theme
	wp_register_script( 'plugin', get_stylesheet_directory_uri() . '/javascripts/plugin.js', array( 'jquery' ), '', true );
}

/**
 * Enqueue scripts
 */
function <%= project_id %>_enqueue_scripts()
{
	wp_enqueue_script( 'plugin' );

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
