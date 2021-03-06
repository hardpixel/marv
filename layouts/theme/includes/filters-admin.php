<?php

// Block direct access
if( ! defined( 'ABSPATH' ) ) exit;

// Only in admin
if( ! is_admin() ) return;

/**
 * Remove contactmethods
 */
function <%= project_id %>_edit_contactmethods( $methods )
{
	unset( $methods['aim'] );
	unset( $methods['jabber'] );
	unset( $methods['yim'] );

	return $methods;
}

add_filter( 'user_contactmethods', '<%= project_id %>_edit_contactmethods' );

/**
 * Add MCE
 */
function <%= project_id %>_enable_more_buttons( $buttons )
{
	$buttons[] = 'hr';

	return $buttons;
}

add_filter( 'mce_buttons', '<%= project_id %>_enable_more_buttons' );

/**
 * Remove menu items
 */
function <%= project_id %>_remove_menu_pages()
{
	remove_menu_page( 'link-manager.php' );
}

add_action( 'admin_menu', '<%= project_id %>_remove_menu_pages' );

/**
 * Remove dashboard widgets
 */
function <%= project_id %>_remove_dashboard_widgets()
{
	global $wp_meta_boxes;

	unset( $wp_meta_boxes['dashboard']['normal']['core']['dashboard_incoming_links'] );
	unset( $wp_meta_boxes['dashboard']['normal']['core']['dashboard_plugins'] );
	unset( $wp_meta_boxes['dashboard']['side']['core']['dashboard_recent_drafts'] );
	unset( $wp_meta_boxes['dashboard']['normal']['core']['dashboard_recent_comments'] );
	unset( $wp_meta_boxes['dashboard']['side']['core']['dashboard_primary'] );
	unset( $wp_meta_boxes['dashboard']['side']['core']['dashboard_secondary'] );
	// unset( $wp_meta_boxes['dashboard']['side']['core']['dashboard_right_now'] );
	// unset( $wp_meta_boxes['dashboard']['side']['core']['dashboard_quick_press'] );
}

add_action( 'wp_dashboard_setup', '<%= project_id %>_remove_dashboard_widgets' );
