FROM fmoody/minetest_deps:latest
MAINTAINER Brains <fmoody@moodman.org>

#
# Create container
#

# Configure portage to create a server only minetest
COPY minetest_portage_use_conf /etc/portage/package.use
COPY minetest_portage_accept_conf /etc/portage/package.accept_keywords
COPY minetest-9999.ebuild /usr/portage/games-action/minetest/minetest-9999.ebuild

RUN ebuild /usr/portage/games-action/minetest/minetest-9999.ebuild digest

# Add minetest user (500 so that it doesn't clash with host uid) and group (35, standard games gid)
RUN groupadd -f -g 35 games && useradd -u 500 -g games -d /var/lib/minetest minetest

# Emerge minetest
#RUN emerge =minetest-9999

#
# Set up container for server behavior
#

# Expose the minetest server port
EXPOSE 30000/udp

# Volumes for logs, worlds, and games
VOLUME ["/var/lib/minetest/.minetest"]

USER minetest

# Default command
CMD ["/usr/bin/minetestserver"]

# Ideas:
#  * Need to modify container to make it easy to build daily/dev minetests...  
#     base on an image just before minetest is built
#  * Verify that multiple worlds can easily be run from final image
#  * Handle logging flexibly...  Syslog and file?
#  * Investigate links...  Possibly for logging and redis/other-db-of-the-day

