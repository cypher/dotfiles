#compdef rustup

_rustup() {
	typeset -A opt_args
	local ret=1

	local context curcontext="$curcontext" state line
    _arguments -s -S -C \
"-v[Enable verbose output]" \
"--verbose[Enable verbose output]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_commands" \
"*:: :->rustup" \
&& ret=0
    case $state in
    (rustup)
        curcontext="${curcontext%:*:*}:rustup-command-$words[1]:"
        case $line[1] in
            (show)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(install)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_install_commands" \
&& ret=0
;;
(update)
_arguments -s -S -C \
"--no-self-update[Don't perform self update when running the `rustup` command]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_update_commands" \
&& ret=0
;;
(default)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_default_commands" \
&& ret=0
;;
(toolchain)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_commands" \
"*:: :->toolchain" \
&& ret=0
case $state in
    (toolchain)
        curcontext="${curcontext%:*:*}:rustup-toolchain-command-$words[1]:"
        case $line[1] in
            (list)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(install)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_install_commands" \
&& ret=0
;;
(uninstall)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_uninstall_commands" \
&& ret=0
;;
(link)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_link_commands" \
&& ret=0
;;
(update)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_update_commands" \
&& ret=0
;;
(add)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_add_commands" \
&& ret=0
;;
(remove)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_toolchain_remove_commands" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(target)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_target_commands" \
"*:: :->target" \
&& ret=0
case $state in
    (target)
        curcontext="${curcontext%:*:*}:rustup-target-command-$words[1]:"
        case $line[1] in
            (list)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(add)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_target_add_commands" \
&& ret=0
;;
(remove)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_target_remove_commands" \
&& ret=0
;;
(install)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_target_install_commands" \
&& ret=0
;;
(uninstall)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_target_uninstall_commands" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(component)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_component_commands" \
"*:: :->component" \
&& ret=0
case $state in
    (component)
        curcontext="${curcontext%:*:*}:rustup-component-command-$words[1]:"
        case $line[1] in
            (list)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(add)
_arguments -s -S -C \
"--toolchain+[]" \
"--target+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_component_add_commands" \
&& ret=0
;;
(remove)
_arguments -s -S -C \
"--toolchain+[]" \
"--target+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_component_remove_commands" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(override)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_override_commands" \
"*:: :->override" \
&& ret=0
case $state in
    (override)
        curcontext="${curcontext%:*:*}:rustup-override-command-$words[1]:"
        case $line[1] in
            (list)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(set)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_override_set_commands" \
&& ret=0
;;
(unset)
_arguments -s -S -C \
"--path+[Path to the directory]" \
"--nonexistent[Remove override toolchain for all nonexistent directories]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(add)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_override_add_commands" \
&& ret=0
;;
(remove)
_arguments -s -S -C \
"--path+[]" \
"--nonexistent[Remove override toolchain for all nonexistent directories]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(run)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_run_commands" \
&& ret=0
;;
(which)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_which_commands" \
&& ret=0
;;
(doc)
_arguments -s -S -C \
"--book[The Rust Programming Language book]" \
"--std[Standard library API documentation]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(man)
_arguments -s -S -C \
"--toolchain+[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_man_commands" \
&& ret=0
;;
(self)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_self_commands" \
"*:: :->self" \
&& ret=0
case $state in
    (self)
        curcontext="${curcontext%:*:*}:rustup-self-command-$words[1]:"
        case $line[1] in
            (update)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(uninstall)
_arguments -s -S -C \
"-y[]" \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(upgrade-data)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(telemetry)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_telemetry_commands" \
"*:: :->telemetry" \
&& ret=0
case $state in
    (telemetry)
        curcontext="${curcontext%:*:*}:rustup-telemetry-command-$words[1]:"
        case $line[1] in
            (enable)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(disable)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(analyze)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(set)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_set_commands" \
"*:: :->set" \
&& ret=0
case $state in
    (set)
        curcontext="${curcontext%:*:*}:rustup-set-command-$words[1]:"
        case $line[1] in
            (default-host)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_set_default-host_commands" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
;;
(completions)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
"1:: :_rustup_completions_commands" \
&& ret=0
;;
(help)
_arguments -s -S -C \
"-h[Prints help information]" \
"--help[Prints help information]" \
"-V[Prints version information]" \
"--version[Prints version information]" \
&& ret=0
;;
        esac
    ;;
esac
}

(( $+functions[_rustup_commands] )) ||
_rustup_commands() {
    local commands; commands=(
        "show:Show the active and installed toolchains" \
"install:Update Rust toolchains" \
"update:Update Rust toolchains" \
"default:Set the default toolchain" \
"toolchain:Modify or query the installed toolchains" \
"target:Modify a toolchain's supported targets" \
"component:Modify a toolchain's installed components" \
"override:Modify directory toolchain overrides" \
"run:Run a command with an environment configured for a given toolchain" \
"which:Display which binary will be run for a given command" \
"doc:Open the documentation for the current toolchain" \
"man:View the man page for a given command" \
"self:Modify the rustup installation" \
"telemetry:rustup telemetry commands" \
"set:Alter rustup settings" \
"completions:Generate completion scripts for your shell" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup commands' commands "$@"
}
(( $+functions[_rustup_component_add_commands] )) ||
_rustup_component_add_commands() {
    local commands; commands=(
        "COMPONENT:" \
    )
    _describe -t commands 'rustup component add commands' commands "$@"
}
(( $+functions[_rustup_override_add_commands] )) ||
_rustup_override_add_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup override add commands' commands "$@"
}
(( $+functions[_rustup_target_add_commands] )) ||
_rustup_target_add_commands() {
    local commands; commands=(
        "TARGET:" \
    )
    _describe -t commands 'rustup target add commands' commands "$@"
}
(( $+functions[_rustup_toolchain_add_commands] )) ||
_rustup_toolchain_add_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup toolchain add commands' commands "$@"
}
(( $+functions[_rustup_telemetry_analyze_commands] )) ||
_rustup_telemetry_analyze_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup telemetry analyze commands' commands "$@"
}
(( $+functions[_rustup_completions_commands] )) ||
_rustup_completions_commands() {
    local commands; commands=(
        "SHELL:" \
    )
    _describe -t commands 'rustup completions commands' commands "$@"
}
(( $+functions[_rustup_component_commands] )) ||
_rustup_component_commands() {
    local commands; commands=(
        "list:List installed and available components" \
"add:Add a component to a Rust toolchain" \
"remove:Remove a component from a Rust toolchain" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup component commands' commands "$@"
}
(( $+functions[_rustup_default_commands] )) ||
_rustup_default_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup default commands' commands "$@"
}
(( $+functions[_rustup_set_default-host_commands] )) ||
_rustup_set_default-host_commands() {
    local commands; commands=(
        "HOST_TRIPLE:" \
    )
    _describe -t commands 'rustup set default-host commands' commands "$@"
}
(( $+functions[_rustup_telemetry_disable_commands] )) ||
_rustup_telemetry_disable_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup telemetry disable commands' commands "$@"
}
(( $+functions[_rustup_doc_commands] )) ||
_rustup_doc_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup doc commands' commands "$@"
}
(( $+functions[_rustup_telemetry_enable_commands] )) ||
_rustup_telemetry_enable_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup telemetry enable commands' commands "$@"
}
(( $+functions[_rustup_component_help_commands] )) ||
_rustup_component_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup component help commands' commands "$@"
}
(( $+functions[_rustup_help_commands] )) ||
_rustup_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup help commands' commands "$@"
}
(( $+functions[_rustup_override_help_commands] )) ||
_rustup_override_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup override help commands' commands "$@"
}
(( $+functions[_rustup_self_help_commands] )) ||
_rustup_self_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup self help commands' commands "$@"
}
(( $+functions[_rustup_set_help_commands] )) ||
_rustup_set_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup set help commands' commands "$@"
}
(( $+functions[_rustup_target_help_commands] )) ||
_rustup_target_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup target help commands' commands "$@"
}
(( $+functions[_rustup_telemetry_help_commands] )) ||
_rustup_telemetry_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup telemetry help commands' commands "$@"
}
(( $+functions[_rustup_toolchain_help_commands] )) ||
_rustup_toolchain_help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup toolchain help commands' commands "$@"
}
(( $+functions[_rustup_install_commands] )) ||
_rustup_install_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup install commands' commands "$@"
}
(( $+functions[_rustup_target_install_commands] )) ||
_rustup_target_install_commands() {
    local commands; commands=(
        "TARGET:" \
    )
    _describe -t commands 'rustup target install commands' commands "$@"
}
(( $+functions[_rustup_toolchain_install_commands] )) ||
_rustup_toolchain_install_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup toolchain install commands' commands "$@"
}
(( $+functions[_rustup_toolchain_link_commands] )) ||
_rustup_toolchain_link_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
"PATH:" \
    )
    _describe -t commands 'rustup toolchain link commands' commands "$@"
}
(( $+functions[_rustup_component_list_commands] )) ||
_rustup_component_list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup component list commands' commands "$@"
}
(( $+functions[_rustup_override_list_commands] )) ||
_rustup_override_list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup override list commands' commands "$@"
}
(( $+functions[_rustup_target_list_commands] )) ||
_rustup_target_list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup target list commands' commands "$@"
}
(( $+functions[_rustup_toolchain_list_commands] )) ||
_rustup_toolchain_list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup toolchain list commands' commands "$@"
}
(( $+functions[_rustup_man_commands] )) ||
_rustup_man_commands() {
    local commands; commands=(
        "COMMAND:" \
    )
    _describe -t commands 'rustup man commands' commands "$@"
}
(( $+functions[_rustup_override_commands] )) ||
_rustup_override_commands() {
    local commands; commands=(
        "list:List directory toolchain overrides" \
"set:Set the override toolchain for a directory" \
"unset:Remove the override toolchain for a directory" \
"add:" \
"remove:Remove the override toolchain for a directory" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup override commands' commands "$@"
}
(( $+functions[_rustup_component_remove_commands] )) ||
_rustup_component_remove_commands() {
    local commands; commands=(
        "COMPONENT:" \
    )
    _describe -t commands 'rustup component remove commands' commands "$@"
}
(( $+functions[_rustup_override_remove_commands] )) ||
_rustup_override_remove_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup override remove commands' commands "$@"
}
(( $+functions[_rustup_target_remove_commands] )) ||
_rustup_target_remove_commands() {
    local commands; commands=(
        "TARGET:" \
    )
    _describe -t commands 'rustup target remove commands' commands "$@"
}
(( $+functions[_rustup_toolchain_remove_commands] )) ||
_rustup_toolchain_remove_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup toolchain remove commands' commands "$@"
}
(( $+functions[_rustup_run_commands] )) ||
_rustup_run_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
"COMMAND:" \
    )
    _describe -t commands 'rustup run commands' commands "$@"
}
(( $+functions[_rustup_self_commands] )) ||
_rustup_self_commands() {
    local commands; commands=(
        "update:Download and install updates to rustup" \
"uninstall:Uninstall rustup." \
"upgrade-data:Upgrade the internal data format." \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup self commands' commands "$@"
}
(( $+functions[_rustup_override_set_commands] )) ||
_rustup_override_set_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup override set commands' commands "$@"
}
(( $+functions[_rustup_set_commands] )) ||
_rustup_set_commands() {
    local commands; commands=(
        "default-host:The triple used to identify toolchains when not specified" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup set commands' commands "$@"
}
(( $+functions[_rustup_show_commands] )) ||
_rustup_show_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup show commands' commands "$@"
}
(( $+functions[_rustup_target_commands] )) ||
_rustup_target_commands() {
    local commands; commands=(
        "list:List installed and available targets" \
"add:Add a target to a Rust toolchain" \
"remove:Remove a target  from a Rust toolchain" \
"install:" \
"uninstall:" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup target commands' commands "$@"
}
(( $+functions[_rustup_telemetry_commands] )) ||
_rustup_telemetry_commands() {
    local commands; commands=(
        "enable:Enable rustup telemetry" \
"disable:Disable rustup telemetry" \
"analyze:Analyze stored telemetry" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup telemetry commands' commands "$@"
}
(( $+functions[_rustup_toolchain_commands] )) ||
_rustup_toolchain_commands() {
    local commands; commands=(
        "list:List installed toolchains" \
"install:Install or update a given toolchain" \
"uninstall:Uninstall a toolchain" \
"link:Create a custom toolchain by symlinking to a directory" \
"update:" \
"add:" \
"remove:" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'rustup toolchain commands' commands "$@"
}
(( $+functions[_rustup_self_uninstall_commands] )) ||
_rustup_self_uninstall_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup self uninstall commands' commands "$@"
}
(( $+functions[_rustup_target_uninstall_commands] )) ||
_rustup_target_uninstall_commands() {
    local commands; commands=(
        "TARGET:" \
    )
    _describe -t commands 'rustup target uninstall commands' commands "$@"
}
(( $+functions[_rustup_toolchain_uninstall_commands] )) ||
_rustup_toolchain_uninstall_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup toolchain uninstall commands' commands "$@"
}
(( $+functions[_rustup_override_unset_commands] )) ||
_rustup_override_unset_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup override unset commands' commands "$@"
}
(( $+functions[_rustup_self_update_commands] )) ||
_rustup_self_update_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup self update commands' commands "$@"
}
(( $+functions[_rustup_toolchain_update_commands] )) ||
_rustup_toolchain_update_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup toolchain update commands' commands "$@"
}
(( $+functions[_rustup_update_commands] )) ||
_rustup_update_commands() {
    local commands; commands=(
        "TOOLCHAIN:" \
    )
    _describe -t commands 'rustup update commands' commands "$@"
}
(( $+functions[_rustup_self_upgrade-data_commands] )) ||
_rustup_self_upgrade-data_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'rustup self upgrade-data commands' commands "$@"
}
(( $+functions[_rustup_which_commands] )) ||
_rustup_which_commands() {
    local commands; commands=(
        "COMMAND:" \
    )
    _describe -t commands 'rustup which commands' commands "$@"
}

_rustup "$@"