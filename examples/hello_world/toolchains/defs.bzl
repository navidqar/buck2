load("@prelude//android:android_toolchain.bzl", "AndroidPlatformInfo", "AndroidToolchainInfo")
load("@prelude//java:dex_toolchain.bzl", "DexToolchainInfo")
load("@prelude//java:java_toolchain.bzl", "JavaPlatformInfo", "JavaToolchainInfo", "PrebuiltJarToolchainInfo")
load("@prelude//kotlin:kotlin_toolchain.bzl", "KotlinToolchainInfo")

FAT_JAR_MAIN_CLASS_LIB = "prelude//toolchains/android/src/com/facebook/buck/jvm/java/fatjar:fat-jar-main-binary"

def _toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    if ctx.attrs.dep != None:
        return ctx.attrs.dep.providers
    return [DefaultInfo()]

toolchain = rule(
    attrs = {"dep": attrs.option(attrs.exec_dep(), default = None)},
    impl = _toolchain_impl,
    is_toolchain_rule = True,
)

def prebuilt_jar_toolchain(name, is_bootstrap_toolchain = False, visibility = None, global_code_config = {}, should_generate_snapshot = True):
    kwargs = {}
    kwargs["is_bootstrap_toolchain"] = is_bootstrap_toolchain
    kwargs["class_abi_generator"] = None
    kwargs["cp_snapshot_generator"] = None
    # kwargs["java"] = "toolchains//:java"
    _prebuilt_jar_toolchain_rule(name = name, visibility = visibility, global_code_config = global_code_config, **kwargs)

def _prebuilt_jar_toolchain_rule_impl(ctx):
    return [
        DefaultInfo(),
        PrebuiltJarToolchainInfo(
            class_abi_generator = ctx.attrs.class_abi_generator,
            cp_snapshot_generator = ctx.attrs.cp_snapshot_generator,
            global_code_config = {},
            is_bootstrap_toolchain = ctx.attrs.is_bootstrap_toolchain,
            # java = ctx.attrs.java,
        ),
    ]

_prebuilt_jar_toolchain_rule = rule(
    attrs = {
        "class_abi_generator": attrs.option(attrs.dep(providers = [RunInfo]), default = None),
        "cp_snapshot_generator": attrs.option(attrs.dep(providers = [RunInfo]), default = None),
        "global_code_config": attrs.dict(key = attrs.string(), value = attrs.tuple(attrs.list(attrs.label()), attrs.list(attrs.label()), attrs.bool())),
        "is_bootstrap_toolchain": attrs.bool(default = False),
        # "java": attrs.dep(),
    },
    impl = _prebuilt_jar_toolchain_rule_impl,
)

def bootstrap_prebuilt_jar(**kwargs):
    kwargs["_prebuilt_jar_toolchain"] = "toolchains//:prebuilt_jar_bootstrap"
    native.prebuilt_jar(**kwargs)

def _android_toolchain_impl(ctx):
    return [
        DefaultInfo(),
        AndroidPlatformInfo(
            name = ctx.attrs.name,
        ),
        AndroidToolchainInfo(
            aapt2 = "//tools:aapt2",
            aapt2_filter_resources = "prelude//android/tools:filter_extra_resources",
            android_bootclasspath = [ctx.attrs.android_jar],
            aar_builder = "prelude//toolchains/android/src/com/facebook/buck/android/aar:aar_builder_binary",
            adb = "//tools:adb",
            aidl = "//tools:aidl",
            android_jar = ctx.attrs.android_jar,
            android_optional_jars = [],  # TODO fill this
            apk_builder = "prelude//toolchains/android/src/com/facebook/buck/android/apk:apk_builder_binary",
            apk_module_graph = "prelude//toolchains/android/src/com/facebook/buck/android/apkmodule:apkmodule_binary",
            app_without_resources_stub = "prelude//android/tools:app_without_resources_stub",
            bundle_apks_builder = "prelude//toolchains/android/src/com/facebook/buck/android/bundle:bundle_apks_builder_binary",
            bundle_builder = "prelude//toolchains/android/src/com/facebook/buck/android/bundle:bundle_builder_binary",
            combine_native_library_dirs = "prelude//android/tools:combine_native_library_dirs",
            copy_string_resources = "prelude//toolchains/android/src/com/facebook/buck/android/resources/strings:copy_string_resources_binary",
            cross_module_native_deps_check = True,
            d8_command = "prelude//toolchains/android/src/com/facebook/buck/android/dex:run_d8_bnary",
            exo_resources_rewriter = "prelude//toolchains/android/src/com/facebook/buck/android/resources:exo_resources_rewriter_binary",
            exopackage_agent_apk = "prelude//toolchains/android/assets/android:agent.apk",
            filter_dex_class_names = "prelude//android/tools:filter_dex",
            filter_prebuilt_native_library_dir = "prelude//android/tools:filter_prebuilt_native_library_dir",
            filter_resources = "prelude//toolchains/android/src/com/facebook/buck/android/resources/filter:filter_resources_binary",
            framework_aidl_file = "//tools:framework_aidl_file",
            generate_build_config = "prelude//toolchains/android/src/com/facebook/buck/android/build_config:generate_build_config_binary",
            generate_manifest = "prelude//toolchains/android/src/com/facebook/buck/android/manifest:generate_manifest_binary",
            installer = "prelude//toolchains/android/src/com/facebook/buck/installer/android:android_installer",
            instrumentation_test_can_run_locally = True,
            instrumentation_test_runner_classpath = [
                # "prelude//toolchains/android/src/com/facebook/buck/testrunner:testrunner-bin-fixed",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/android:common",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/android:ddmlib",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/guava:guava-jar",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/guava:failureaccess",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/guava:listenablefuture",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/kxml2:kxml2",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/protobuf:protobuf",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/jackson:jackson-annotations",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/jackson:jackson-core",
                # "fbsource//xplat/toolchains/android/sdk/third-party/java/jackson:jackson-databind-jar",
            ],
            instrumentation_test_runner_main_class = "com.facebook.buck.testrunner.InstrumentationMain",
            jar_splitter_command = "prelude//toolchains/android/src/com/facebook/buck/android/dex:jar_splitter_binary",
            manifest_utils = "prelude//toolchains/android/src/com/facebook/buck/android:manifest_utils_binary",
            merge_android_resource_sources = "prelude//toolchains/android/src/com/facebook/buck/android/aapt:merge_android_resource_sources_binary",
            merge_android_resources = "prelude//toolchains/android/src/com/facebook/buck/android/resources:merge_android_resources_binary",
            merge_assets = "prelude//toolchains/android/src/com/facebook/buck/android/resources:merge_assets_binary",
            mergemap_tool = "prelude//android/tools:compute_merge_sequence",
            mini_aapt = "prelude//toolchains/android/src/com/facebook/buck/android/aapt:mini_aapt_binary",
            multi_dex_command = "prelude//toolchains/android/src/com/facebook/buck/android/dex:multi_dex_binary",
            native_libs_as_assets_metadata = "prelude//android/tools:native_libs_as_assets_metadata",
            # optimized_proguard_config = "fbsource//third-party/toolchains/android-sdk:optimized_proguard_config",
            # p7zip = "fbsource//fbandroid/facebook/apk-size:7z",
            package_meta_inf_version_files = False,
            package_strings_as_assets = "prelude//toolchains/android/src/com/facebook/buck/android/resources/strings:package_strings_as_assets_binary",
            prebuilt_aar_resources_have_low_priority = False,
            # proguard_config = "fbsource//third-party/toolchains/android-sdk:proguard_config",
            # proguard_jar = "fbsource//third-party/toolchains/android-sdk:proguard.jar",
            proguard_max_heap_size = "1024M",
            r_dot_java_weight_factor = 8,
            replace_application_id_placeholders = "prelude//toolchains/android/src/com/facebook/buck/android/manifest:replace_application_id_placeholders_binary",
            secondary_dex_compression_command = "prelude//toolchains/android/src/com/facebook/buck/android/dex:secondary_dex_compression_binary",
            secondary_dex_weight_limit = 12 * 1024 * 1024,
            set_application_id_to_specified_package = False,
            should_run_sanity_check_for_placeholders = False,
            unpack_aar = "prelude//android/tools:unpack_aar",
            # zipalign = "fbsource//third-party/toolchains/android-sdk:zipalign_and_deps",
        ),
    ]

def _kotlin_toolchain_impl(ctx):
    return [
        DefaultInfo(),
        KotlinToolchainInfo(
            # annotation_processing_jar = "fbsource//xplat/toolchains/android/sdk/third-party/java/kotlin:kotlin-annotation-processing-embeddable",
            compile_kotlin = "prelude//kotlin/tools/compile_kotlin:compile_kotlin",
            kapt_base64_encoder = "prelude//kotlin/tools/kapt_base64_encoder:kapt_base64_encoder",
            # kotlin_stdlib = "fbsource//xplat/toolchains/android/sdk/third-party/java/kotlin:kotlin-stdlib",
            kotlin_version = "2.0.0",  # wire to config?
            #protocol_override_for_tests = read_non_empty_string("test", "kotlinc_protocol_for_testing_purpose_only"),
            kotlinc_protocol = "classic",  # what aobut kotlincd?
            # kotlinc = "fbsource//third-party/kotlin:kotlin-compiler-binary",
            dep_files = None,
        ),
    ]

def _java_toolchain_impl(ctx):
    return [
        DefaultInfo(),
        JavaPlatformInfo(
            name = ctx.attrs.name,
        ),
        JavaToolchainInfo(
            compile_and_package = ctx.attrs.compile_and_package,
            gen_class_to_source_map = ctx.attrs.gen_class_to_source_map,
            gen_class_to_source_map_include_sourceless_compiled_packages = ctx.attrs.gen_class_to_source_map_include_sourceless_compiled_packages,
            gen_class_to_source_map_debuginfo = None,
            fat_jar = "prelude//java/tools:fat_jar",
            jar = "//tools:jar",
            jar_builder = RunInfo(cmd_args([ctx.attrs.java[RunInfo], "-jar", ctx.attrs.jar_builder])),
            java = "//tools:java",
            track_class_usage = True,
            zip_scrubber = "prelude//toolchains/android/src/com/facebook/buck/util/zip:zip_scrubber",
            is_bootstrap_toolchain = True,
            # set none for tools that don't used for bootstrap toolchain
            class_abi_generator = None,
            cp_snapshot_generator = None,
            fat_jar_main_class_lib = None,
            nullsafe = None,
            nullsafe_extra_args = [],
            nullsafe_signatures = None,
            javac_protocol = "classic",  #TODO javacd
            dep_files = None,
            javac = ctx.attrs.javac,
            global_code_config = {},
        ),
    ]

java_toolchain = rule(
    impl = _java_toolchain_impl,
    is_toolchain_rule = True,
    attrs = {
        "compile_and_package": attrs.dep(default = "prelude//java/tools:compile_and_package"),
        "gen_class_to_source_map": attrs.exec_dep(
            default = "prelude//java/tools:gen_class_to_source_map",
            providers = [RunInfo],
        ),
        "gen_class_to_source_map_include_sourceless_compiled_packages": attrs.list(attrs.string(), default = [
            "androidx.databinding",
        ]),
        "jar_builder": attrs.source(default = "prelude//toolchains/android/src/com/facebook/buck/util/zip:jar_builder"),
        "java": attrs.dep(default = "root//tools:java"),
        "javac": attrs.exec_dep(default = "root//tools:javac", providers = [RunInfo]),
    },
)

def android_toolchain_outer(name, android_jar, **kwargs):
    # android_jar = android_jar or "fbsource//third-party/toolchains/android-sdk:android.jar
    android_toolchain(name = name, android_jar = android_jar, **kwargs)

android_toolchain = rule(
    impl = _android_toolchain_impl,
    is_toolchain_rule = True,
    attrs = {
        "android_jar": attrs.source(),
    },
)

kotlin_toolchain = rule(
    impl = _kotlin_toolchain_impl,
    is_toolchain_rule = True,
    attrs = {},
)

def empty_dex_toolchain(
        name,
        **kwargs):
    _config_backed_dex_toolchain_rule(
        name = name,
        **kwargs
    )

def config_backed_dex_toolchain(
        name,
        **kwargs):
    # TODO(T107163344) These don't belong here! Move out to Android toolchain once we have overlays.
    kwargs["android_jar"] = None
    kwargs["d8_command_binary"] = None

    _config_backed_dex_toolchain_rule(
        name = name,
        **kwargs
    )

def _config_backed_dex_toolchain_rule_impl(ctx):
    return [
        DefaultInfo(),
        DexToolchainInfo(
            android_jar = ctx.attrs.android_jar,
            d8_command = ctx.attrs.d8_command_binary,
        ),
    ]

_config_backed_dex_toolchain_rule = rule(
    attrs = {
        "android_jar": attrs.option(attrs.source(), default = None),
        "d8_command_binary": attrs.option(attrs.dep(providers = [RunInfo]), default = None),
    },
    impl = _config_backed_dex_toolchain_rule_impl,
    is_toolchain_rule = True,
)
