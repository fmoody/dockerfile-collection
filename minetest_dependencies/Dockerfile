# Build an image of the minetest dependencies
FROM fmoody/funtoo:latest
MAINTAINER Brains <fmoody@moodman.org>

#
# Create container
#

# Configure portage to create a server only minetest
COPY minetest_portage_conf /etc/portage/package.use

# Emerge minetest dependencies
RUN emerge --onlydeps minetest

