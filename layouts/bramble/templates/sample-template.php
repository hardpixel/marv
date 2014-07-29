<?php

/**
*
* Template Name: Sample Template
*
**/

get_header(); ?>

	<div id="content">

		<?php bramble_content_before(); ?>

		<?php if ( have_posts() ) : while ( have_posts() ) : the_post(); ?>

			<?php get_template_part( 'content', get_post_format() ); ?>

		<?php endwhile; endif; ?>

		<?php bramble_content_after(); ?>

	</div>

<?php get_footer(); ?>