#!/bin/bash
set -e

# Clone the Ly repository
git clone https://codeberg.org/fairyglade/ly.git /tmp/ly
cd /tmp/ly

# Download and extract Zig 0.15.1
curl -L -o zig.tar.xz https://ziglang.org/download/0.15.1/zig-x86_64-linux-0.15.1.tar.xz
tar -xf zig.tar.xz
export PATH="/tmp/ly/zig-x86_64-linux-0.15.1:$PATH"

# Build Ly
zig build

# Install Ly (assuming systemd as the init system)
zig build installexe -Dinit_system=systemd

# Clean up
cd /
rm -rf /tmp/ly
