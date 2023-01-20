const original = [{
    "Info": "Stroman, Rempel and Koepp",
    "StreetAddress": "2 Judy Junction",
    "Address2": "PO Box 3577",
    "StateOrProvince": "Alabama",
    "PostalCode": "35236",
    "Country": "United States"
  }, {
    "Info": "Vandervort, Koepp and Hintz",
    "StreetAddress": "7835 Clarendon Avenue",
    "Address2": "PO Box 62915",
    "StateOrProvince": "Florida",
    "PostalCode": "33680",
    "Country": "United States"
  }, {
    "Info": "Batz, Mohr and Conn",
    "StreetAddress": "10 Grim Center",
    "Address2": "13th Floor",
    "StateOrProvince": "New York",
    "PostalCode": "14609",
    "Country": "United States"
  }, {
    "Info": "Leannon Group",
    "StreetAddress": "41601 Sloan Crossing",
    "Address2": "Room 1858",
    "StateOrProvince": "Virginia",
    "PostalCode": "23471",
    "Country": "United States"
  }, {
    "Info": "Beahan-Toy",
    "StreetAddress": "335 Hermina Terrace",
    "Address2": "20th Floor",
    "StateOrProvince": "Washington",
    "PostalCode": "98008",
    "Country": "United States"
  }, {
    "Info": "Larkin, Muller and Vandervort",
    "StreetAddress": "77262 Kedzie Center",
    "Address2": "PO Box 90747",
    "StateOrProvince": "North Carolina",
    "PostalCode": "28230",
    "Country": "United States"
  }, {
    "Info": "Kerluke-Rippin",
    "StreetAddress": "5369 Monica Parkway",
    "Address2": "Apt 1915",
    "StateOrProvince": "New York",
    "PostalCode": "11247",
    "Country": "United States"
  }, {
    "Info": "Rempel, Bogan and Barrows",
    "StreetAddress": "6 Twin Pines Hill",
    "Address2": "10th Floor",
    "StateOrProvince": "Massachusetts",
    "PostalCode": "02216",
    "Country": "United States"
  }, {
    "Info": "Breitenberg, Dietrich and Morissette",
    "StreetAddress": "19 Northfield Lane",
    "Address2": "18th Floor",
    "StateOrProvince": "Colorado",
    "PostalCode": "80525",
    "Country": "United States"
  }, {
    "Info": "Kuhlman-Goodwin",
    "StreetAddress": "69350 Kim Parkway",
    "Address2": "Apt 1543",
    "StateOrProvince": "Texas",
    "PostalCode": "79934",
    "Country": "United States"
  }, {
    "Info": "Pouros-Lakin",
    "StreetAddress": "003 Goodland Alley",
    "Address2": "Apt 1126",
    "StateOrProvince": "Virginia",
    "PostalCode": "23612",
    "Country": "United States"
  }, {
    "Info": "Paucek-Hartmann",
    "StreetAddress": "12949 Waubesa Drive",
    "Address2": "Room 1101",
    "StateOrProvince": "Texas",
    "PostalCode": "79405",
    "Country": "United States"
  }, {
    "Info": "Sipes and Sons",
    "StreetAddress": "74868 Almo Alley",
    "Address2": "Suite 19",
    "StateOrProvince": "Arizona",
    "PostalCode": "85099",
    "Country": "United States"
  }, {
    "Info": "Torp and Sons",
    "StreetAddress": "5 Monument Way",
    "Address2": "Room 845",
    "StateOrProvince": "Texas",
    "PostalCode": "75379",
    "Country": "United States"
  }, {
    "Info": "Schultz, Hickle and Barton",
    "StreetAddress": "2337 Transport Drive",
    "Address2": "Suite 79",
    "StateOrProvince": "New York",
    "PostalCode": "10079",
    "Country": "United States"
  }, {
    "Info": "Parker Group",
    "StreetAddress": "94 Jenifer Junction",
    "Address2": "10th Floor",
    "StateOrProvince": "Georgia",
    "PostalCode": "31190",
    "Country": "United States"
  }, {
    "Info": "Lubowitz-O'Keefe",
    "StreetAddress": "6 Hazelcrest Plaza",
    "Address2": "5th Floor",
    "StateOrProvince": "Texas",
    "PostalCode": "76505",
    "Country": "United States"
  }, {
    "Info": "McDermott-Spencer",
    "StreetAddress": "15 Graceland Park",
    "Address2": "Suite 94",
    "StateOrProvince": "Missouri",
    "PostalCode": "64142",
    "Country": "United States"
  }, {
    "Info": "Gulgowski, Collier and Homenick",
    "StreetAddress": "0739 Lyons Road",
    "Address2": "Room 482",
    "StateOrProvince": "Tennessee",
    "PostalCode": "37919",
    "Country": "United States"
  }, {
    "Info": "Yost-Lind",
    "StreetAddress": "2 Talisman Crossing",
    "Address2": "4th Floor",
    "StateOrProvince": "Alabama",
    "PostalCode": "36109",
    "Country": "United States"
  }];

   original.forEach(supplier => {
    supplier.Address = {};
    for (const property in supplier) {
        if(property === "Info") {
            const info = { 
                "Name": supplier[property]
            }
            supplier.Info = info;
        } 
        else if(property !== "Address") {
            supplier.Address[property] = supplier[property];
            delete supplier[property];
        }        
      }
   });
   console.log(JSON.stringify(original));



