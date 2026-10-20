days = [
    "First", "Second", "Third", "Fourth",
    "Fifth", "Sixth", "Seventh", "Eigth",
    "Ninth", "Tenth", "Eleventh", "Twelfth"
]

gifts = [
    "A Partridge in a Pear Tree",
    "Two Turtle Doves, and",
    "Three French Hens",
    "Four Colly Birds",
    "Five Gold Rings",
    "Six Geese-a-Laying",
    "Seven Swans-a-Swimming",
    "Eight Maids-a-Milking",
    "Nine Ldaies Dancing",
    "Ten Lords-a-Leaping",
    "Eleven Pipers Piping",
    "Twelve Drummers Drumming"
]

for day in range(12):
    print(f"On the {days[day]} day of Christmas my true love gave to me:")
    for gift in range(day, -1, -1):
        print(gifts[gift])
    if day < 11:
        print()
