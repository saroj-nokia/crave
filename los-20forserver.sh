#!/bin/bash

# Automatic cleanup
echo "Performing cleanup..."
rm -rf .repo/local_manifests/
echo "Cleanup completed."
echo ""

# Initialize the ROM source repository
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
if [ $? -ne 0 ]; then
    echo "Repo initialization failed. Exiting."
    exit 1
fi
echo "================="
echo "Repo init success"
echo "================="
echo ""

# Clone local manifests
git clone https://github.com/saroj-nokia/local_manifests.git -b lineage-20-rosy .repo/local_manifests
if [ $? -ne 0 ]; then
    echo "Failed to clone local manifests. Exiting."
    exit 1
fi
echo "============================"
echo "Local manifest clone success"
echo "============================"
echo ""

# Sync the repositories using the Crave sync script
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j14
if [ $? -ne 0 ]; then
    echo "Repo sync failed. Exiting."
    exit 1
fi
echo "============================"
echo "Repo sync success"
echo "============================"
echo ""

# Build environment setup
source build/envsetup.sh
export BUILD_USERNAME=sarojtaj77
export BUILD_HOSTNAME=T800-machine

# Build the ROM
breakfast rosy user
if [ $? -ne 0 ]; then
    echo "Breakfast failed. Exiting."
    exit 1
fi

make installclean
if [ $? -ne 0 ]; then
    echo "Installclean failed. Exiting."
    exit 1
fi

mka bacon
if [ $? -ne 0 ]; then
    echo "Build failed. Exiting."
    exit 1
fi

echo "============================"
echo "Build process completed successfully!"
echo "============================"

# Upload ROM zip file to PixelDrain
ROM_DIR="out/target/product/rosy/"
ROM_NAME=$(ls $ROM_DIR | grep "lineage-20.0-.*-UNOFFICIAL-rosy.zip$" | tail -n 1)

if [ -n "$ROM_NAME" ]; then
    ROM_PATH="$ROM_DIR$ROM_NAME"
    echo "Uploading ROM file to PixelDrain..."
    curl -T "$ROM_PATH" -u :d948712b-edd9-4073-bdbc-b59c3f8a4392 https://pixeldrain.com/api/file/
    if [ $? -eq 0 ]; then
        echo "ROM uploaded successfully to PixelDrain!"
    else
        echo "Failed to upload ROM to PixelDrain. Check your network or credentials."
    fi
else
    echo "ROM file not found. Upload skipped."
fi

echo "============================"
echo "ROM uploaded successfully to PixelDrain!"
echo "============================"
