# WorkLog
WorkLog is a simple tool for easily time tracking of working activities to minimize the needed time to inserting into timetracking software (e.g. BlueAnt, SAP CATS).

# Requirements
WorkLog requires [Ruby][1] and Bundler

# How to use 
## Setup

    bin/setup

## Start on windows
Change your working directory to the root of this repository and execute the following command

    ./bin/worklog

## Get some help

    worklog> -h
    Usage:
            worklog [start [HH[:MM]]] [done [-d [H]h[M]m] text] [pause [-d [H]h[M]m] text] [list [-l]]
            worklog done -d 1h "SNR nftables"
            worklog delete
            worklog pause -d 30m
            worklog start 8
            worklog ls
            worklog ls -l

    Options:
            d, done          Log your activity
            del, delete      Delete an activity or the day
            ls, list         Grouped output of work journal
            p, pause         Log your break
            s, start         Start your working day and specify the time ([HH[:MM]])
            -d               Specify the duration ([H]h[M]m)
            -l               Extended output of work journal
            --full-day       The whole day will be deleted for delete
            -h, --help       Show this help
            -v, --version    Show the version number (0.0.1)
 
## Start your working day

    worklog start 8  

## Log an activity
Logging an activity is done by using `done` and the description of the activity. The actual time is set as the end time of this activity.

    done "Implementation"

It is also possible to specify the spend time for an activity.

    done -d 1h "Testing" 

It is also possible to group activites to a specific topics. When the activity text is starting with a word in uppercase, this is parsed as the topic. All activities are grouped by their topic in the list view.

    done -d 30m "SNR eepd nftables"  # logs text "eepd nftables" and topic "SNR"

## Log a break
Logging a break is done by using `pause` and the description of the activity. It is alos possible to specify the duration (same way as for an activity).

    pause -d 40m "Doener" 

## Delete entries
In case of an wrongly logged activity, it is possible to delete this one by using `delete`. It will delete the last activity of the current working day.

    delete

The whole day can also be delete by using the option `--full-day`with the command delete.

    delete --full-day


## View the journal
View the journal and only output the grouped aggreageted times. The first line of every day contains the date, the start time (S), the end time (E) and the amount of pause time (P).
    
    list

    2019-03-27: S 08:00 - E 10:40 * P 00:30
              01:66 - SNR
              00:50 - ADMIN

Be careful, the output displays the minutes of the activities.

For a jourfix it can be important also see the logged activities in datail. For this case use the `-l` option.

    list -l

    2019-03-27: S 10:00 - E 18:10 * P 00:40
              07:50 - SNR
        Details
             01:00 - Testing (SNR)
             01:00 - documentation (SNR)
             01:66 - documentation (SNR)
             03:83 - development (SNR)
             00:66 - mittag ()

## Aliases

There are short aliases for all commands:

|Command|Alias|
|---|---|
|done|d|
|delete|del|
|list|ls| 
|pause|p|
|start|s|

# Development

You are invited to commit any changes which might improve the usuability.
Please execute `./bin/spec` before pushing your changes.

# License
WorkLog is released under the [MIT License](http://opensource.org/licenses/MIT). Please see `LICENSE.txt` for details.


[1]: http://rubyinstaller.org/
