#!/bin/bash

# Automatic cleanup
echo "Performing cleanup..."
rm -rf .repo/local_manifests/
rm -rf hardware/qcom-caf/common
rm -rf packages/apps/Updater
rm -rf packages/apps/ThemePicker
rm -rf packages/apps/Settings
rm -rf vendor/qcom/opensource/healthd-ext
rm -rf system/media
rm -rf hardware/interfaces
echo "Cleanup completed."
echo ""

# Initialize the ROM source repository
repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --git-lfs
if [ $? -ne 0 ]; then
    echo "Repo initialization failed. Exiting."
    exit 1
fi
echo "================="
echo "Repo init success"
echo "================="
echo ""

# Clone local manifests
git clone https://github.com/saroj-nokia/local_manifests_sapphire --depth 1 -b sapphire15 .repo/local_manifests
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

# Automatic cleanup
echo "Performing cleanup..."
rm -rf packages/apps/Updater
rm -rf packages/apps/ThemePicker
rm -rf packages/apps/Settings
rm -rf system/media
rm -rf hardware/interfaces
echo "Cleanup completed."
echo ""

# Clone modified lineage updater repo
echo "Clone modified lineage updater repo"
git clone https://github.com/sapphire-sm6225/android_packages_apps_Updater -b lineage-22.2 packages/apps/Updater
echo "============================"
echo "modified lineage updater repo clone success"
echo "============================"
echo ""

# Clone modified lineage ThemePicke repo
echo "Clone modified lineage ThemePicker repo"
git clone https://github.com/sapphire-sm6225/android_packages_apps_ThemePicker -b lineage-22.2 packages/apps/ThemePicker
echo "============================"
echo "modified lineage ThemePicker repo clone success"
echo "============================"
echo ""

# Clone modified lineage Settings repo
echo "Clone modified lineage Settings repo"
git clone https://github.com/sapphire-sm6225/android_packages_apps_Settings -b lineage-22.2 packages/apps/Settings
echo "============================"
echo "modified lineage Settings repo clone success"
echo "============================"
echo ""

# Clone modified no audio tonhtone while bluetooth connect repo
echo "Clone modified no audio tonhtone while bluetooth connect repo"
git clone https://github.com/sapphire-sm6225/android_system_media.git -b lineage-22.2 system/media
echo "============================"
echo "modified lineage no audio tonhtone while bluetooth connect repo clone success"
echo "============================"
echo ""

# Clone modified no audio tonhtone while bluetooth connect repo
echo "Clone modified no audio tonhtone while bluetooth connect repo"
git clone https://github.com/sapphire-sm6225/android_hardware_interfaces.git -b lineage-22.2 hardware/interfaces
echo "============================"
echo "modified lineage no audio tonhtone while bluetooth connect repo clone success"
echo "============================"
echo ""

# Clone HALs for SM6225
echo "Cloning HALs for SM6225..."
rm -rf hardware/qcom-caf/common
git clone --depth 1 -b lineage-22.2 https://github.com/sapphire-sm6225/android_hardware_qcom-caf_common.git hardware/qcom-caf/common

rm -rf hardware/qcom-caf/sm6225/audio/agm
git clone --depth 1 -b lineage-22.2-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_agm.git hardware/qcom-caf/sm6225/audio/agm

rm -rf hardware/qcom-caf/sm6225/audio/pal
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_arpal-lx.git hardware/qcom-caf/sm6225/audio/pal

rm -rf hardware/qcom-caf/sm6225/data-ipa-cfg-mgr
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_data-ipa-cfg-mgr.git hardware/qcom-caf/sm6225/data-ipa-cfg-mgr

rm -rf hardware/qcom-caf/sm6225/dataipa
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_dataipa.git hardware/qcom-caf/sm6225/dataipa

rm -rf hardware/qcom-caf/sm6225/display
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/hardware_qcom_display.git hardware/qcom-caf/sm6225/display

rm -rf hardware/qcom-caf/sm6225/media
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/hardware_qcom_media.git hardware/qcom-caf/sm6225/media

rm -rf hardware/qcom-caf/sm6225/audio/primary-hal
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/hardware_qcom_audio.git hardware/qcom-caf/sm6225/audio/primary-hal

rm -rf device/qcom/sepolicy_vndr/sm6225
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/device_qcom_sepolicy_vndr.git device/qcom/sepolicy_vndr/sm6225

rm -rf vendor/qcom/opensource/healthd-ext
git clone --depth 1 -b lineage-22.2 https://github.com/sapphire-sm6225/android_vendor_qcom_opensource_healthd-ext.git vendor/qcom/opensource/healthd-ext
echo "============================"
echo "Cloning HALs completed"
echo "============================"
echo ""

# Build environment setup
source build/envsetup.sh
export BUILD_USERNAME=sarojtaj77
export BUILD_HOSTNAME=T800-machine
export ALLOW_MISSING_DEPENDENCIES=true
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# Build the ROM
breakfast sapphire user
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
ROM_DIR="out/target/product/sapphire/"
ROM_NAME=$(ls $ROM_DIR | grep "lineage-22.2-.*-UNOFFICIAL-sapphire.zip$" | tail -n 1)

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
