
// The 'run' function is called by LaunchBar when the user opens the action.
function run(arguments)
{
    var reverse = LaunchBar.options.shiftKey;

    // Sort the lines:
    var lines = arguments.sort(function(line1, line2) {
                                   if (reverse) {
                                       return line2.localeCompare(line1);
                                   } else {
                                       return line1.localeCompare(line2);
                                   }
                               });

    // Check if the Command key is down:
    if (LaunchBar.options.commandKey) {
        // Paste the sorted lines:
        LaunchBar.paste(lines.join('\n'));
    } else {
        // Return the lines so they can be used in LaunchBar:
        return lines;
    }
}
