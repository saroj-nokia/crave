#!/bin/bash

rm -rf .repo/local_manifests/

rm -rf hardware/qcom-caf/common

# ROM source repo
repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --git-lfs
echo "================="
echo "Repo init success"
echo "================="
echo ""

# Clone local_manifests repository
git clone https://github.com/saroj-nokia/local_manifests_sapphire --depth 1 -b sapphire15 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"
echo ""

# Sync the repositories
/opt/crave/resync.sh
echo "============================"
echo ""

# clone hals for sm6225
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
echo "============================"
echo "clone hals for sm6225 success"
echo "============================"
echo ""

# Build
source build/envsetup.sh
export BUILD_USERNAME=sarojtaj77
export BUILD_HOSTNAME=T800-machine
export ALLOW_MISSING_DEPENDENCIES=true
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
breakfast sapphire user
make installclean
mka bacon
