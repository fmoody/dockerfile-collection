# Build an image of the minetest dependencies
FROM fmoody/funtoo:latest
MAINTAINER Brains <fmoody@moodman.org>

#
# Create container
#

# Add torrent user (1001 so that it doesn't clash with host uid) and group (1001)
RUN groupadd -f -g 1001 torrent && useradd -u 500 -g torrent torrent

# Enable various bits to allow rtorrent to run daemon-y.
ENV USE="daemon"

# Emerge minetest dependencies
RUN emerge tmux rtorrent

#
# Set up container for server behavior
#

# Volumes for config and storage
VOLUME ["/home/torrent"]

USER torrent
WORKDIR /home/torrent

# Default command
CMD ["tmux", "-S /home/torrent/tmux_socket", "new-session", "-d /usr/bin/rtorrent"]
