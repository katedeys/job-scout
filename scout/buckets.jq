# Maps a job's location text to a country bucket for the Telegram country buttons.
def bucket:
  (.location // "" | ascii_downcase) as $l
  | if   ($l|test("netherlands|amsterdam|rotterdam|utrecht|eindhoven")) then "NL"
    elif ($l|test("united kingdom|\\buk\\b|london|england|manchester|edinburgh|leeds|bristol|scotland")) then "UK"
    elif ($l|test("germany|berlin|munich|münchen|hamburg|frankfurt|cologne")) then "DE"
    elif ($l|test("austria|vienna|wien|graz|linz")) then "AT"
    elif ($l|test("israel|tel aviv|tel-aviv|herzliya|jerusalem|haifa|ramat gan|petah")) then "IL"
    elif ($l|test("uae|dubai|abu dhabi|united arab emirates")) then "AE"
    elif ($l|test("armenia|yerevan")) then "AM"
    elif ($l|test("serbia|belgrade|novi sad")) then "RS"
    elif ($l|test("georgia|tbilisi|batumi")) then "GE"
    elif ($l|test("spain|madrid|barcelona|valencia|portugal|lisbon|porto")) then "ESPT"
    elif ($l|test("poland|warsaw|krakow|wroclaw")) then "PL"
    elif ($l|test("france|paris|ireland|dublin|italy|milan|sweden|stockholm|denmark|copenhagen|belgium|brussels|luxembourg|czech|prague|estonia|tallinn|latvia|riga|lithuania|vilnius|cyprus|limassol|malta|greece|athens|bulgaria|sofia|romania|bucharest|hungary|budapest|croatia|zagreb|finland|helsinki|norway|oslo|switzerland|zurich")) then "EU"
    elif ($l|test("remote|anywhere|worldwide|emea|europe")) then "REMOTE"
    else "OTHER" end;
def bucket_label($b):
  {"NL":"🇳🇱 Нидерланды","UK":"🇬🇧 UK","DE":"🇩🇪 Германия","AT":"🇦🇹 Австрия","IL":"🇮🇱 Израиль","AE":"🇦🇪 ОАЭ",
   "AM":"🇦🇲 Армения","RS":"🇷🇸 Сербия","GE":"🇬🇪 Грузия","ESPT":"🇪🇸🇵🇹 Испания/Португалия","PL":"🇵🇱 Польша","EU":"🇪🇺 Другие страны ЕС",
   "REMOTE":"🌍 Remote","OTHER":"🌐 Другие"}[$b];
