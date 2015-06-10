## Welcome to Teecket

Teecket is a gem that will search from AirAsia, Firefly, Malaysia Airlines and
Malindo Air from the comfort of your command line.

## Installation

At the command prompt, install it using `gem`:

    gem install teecket

## Usage

This is an example for a working command:

    teecket KUL KBR 30-07-2015

If you're unsure, typing just the `teecket` will yield:

    teecket KBR KUL 30-07-2015

This is an example of an output:

    +-------------------+----------+--------+-------------+----------+----------+-----------+
    | Flight            | Flight # | Origin | Destination | Depart   | Arrive   | Fare (RM) |
    +-------------------+----------+--------+-------------+----------+----------+-----------+
    | AirAsia           | AK6431   | KBR    | KUL         | 08:00 AM | 09:00 AM | 69.00     |
    | AirAsia           | AK6433   | KBR    | KUL         | 09:25 AM | 10:25 AM | 69.00     |
    | AirAsia           | AK6435   | KBR    | KUL         | 12:05 PM | 01:10 PM | 69.00     |
    | AirAsia           | AK6437   | KBR    | KUL         | 02:50 PM | 03:50 PM | 69.00     |
    | AirAsia           | AK6439   | KBR    | KUL         | 05:25 PM | 06:30 PM | 69.00     |
    | AirAsia           | AK6441   | KBR    | KUL         | 06:55 PM | 07:55 PM | 69.00     |
    | AirAsia           | AK6449   | KBR    | KUL         | 08:55 PM | 10:00 PM | 69.00     |
    | AirAsia           | AK6443   | KBR    | KUL         | 09:55 PM | 10:55 PM | 69.00     |
    | AirAsia           | AK6447   | KBR    | KUL         | 11:15 PM | 12:15 AM | 39.01     |
    | Malaysia Airlines | MH1427   | KBR    | KUL         | 06:25 AM | 07:25 AM | 185.50    |
    | Malaysia Airlines | MH1389   | KBR    | KUL         | 12:30 PM | 01:30 PM | 185.50    |
    | Malaysia Airlines | MH1397   | KBR    | KUL         | 04:10 PM | 05:10 PM | 185.50    |
    | Malindo Air       | OD2301   | KBR    | KUL         | 12:15 AM | 01:15 AM | 41.35     |
    | Malindo Air       | OD2303   | KBR    | KUL         | 09:50 AM | 10:50 AM | 61.35     |
    +-------------------+----------+--------+-------------+----------+----------+-----------+

## Contributing

It'll help this gem stay alive, so, please do :)

## License

Teecket is released under the [MIT
License](http://www.opensource.org/licenses/MIT).
