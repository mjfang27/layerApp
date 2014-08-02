#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140628105322170_drop_and_clean_case_indent_dates_uniques.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140628114921198_remove_creator_id_from_tombstone_wipe_for_ordering.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140701095427050_add_trigger_for_messaging_receipts.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140701114842931_add_timestamps_back_to_messages.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140701144934637_adjust_constraints_of_receipts_table.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140706185141044_add_object_identifiers.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140707082435390_drop_tombstone_trigger.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140707175635814_add_is_draft_to_messages.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140708092626927_adjust_triggers_for_drafting.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140708154438053_change_insert_trigger_on_messages.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140709095453868_drop_track_sending_of_messages.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140715104949748_drop_message_index_table_add_message_index_column.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140717013309255_drop_is_draft_from_messages.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/20140717021208447_restore-lost-triggers.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle/layer-client-messaging-schema.sql"
install_resource "LayerKit/LayerKit.framework/Versions/A/Resources/layer-client-messaging-schema.bundle"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
