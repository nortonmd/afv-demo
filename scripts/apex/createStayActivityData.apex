// Create a sample Contact (Guest)
Contact guest = new Contact(
    FirstName = 'Sarah',
    LastName = 'Anderson',
    Email = 'sarah.anderson@example.com',
    Phone = '(555) 123-4567'
);
insert guest;

System.debug('Created Contact: ' + guest.Id);

// Create 10 sample Stay Activity records
List<Stay_Activity__c> activities = new List<Stay_Activity__c>();

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Dining',
    Activity_Name__c = 'Oceanview Restaurant - Dinner',
    Activity_Date_Time__c = DateTime.now().addDays(-2).addHours(19),
    Duration_Minutes__c = 90,
    Cost__c = 125.50,
    Location__c = 'Oceanview Restaurant - Main Dining Room',
    Status__c = 'Completed',
    Guest_Rating__c = 5.0,
    Notes__c = 'Guest requested table by the window. Celebrated anniversary.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Spa Treatment',
    Activity_Name__c = 'Deep Tissue Massage',
    Activity_Date_Time__c = DateTime.now().addDays(-1).addHours(10),
    Duration_Minutes__c = 60,
    Cost__c = 150.00,
    Location__c = 'Serenity Spa - Treatment Room 3',
    Status__c = 'Completed',
    Guest_Rating__c = 4.5,
    Notes__c = 'Guest preferred medium pressure. Very relaxing experience.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Excursion',
    Activity_Name__c = 'Snorkeling Adventure',
    Activity_Date_Time__c = DateTime.now().addDays(-1).addHours(14),
    Duration_Minutes__c = 180,
    Cost__c = 85.00,
    Location__c = 'Coral Bay Beach - Departure Point',
    Status__c = 'Completed',
    Guest_Rating__c = 5.0,
    Notes__c = 'Guest saw sea turtles! Provided underwater camera.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Pool & Beach',
    Activity_Name__c = 'Poolside Cabana Rental',
    Activity_Date_Time__c = DateTime.now().addHours(-5),
    Duration_Minutes__c = 240,
    Cost__c = 75.00,
    Location__c = 'Infinity Pool - Cabana 12',
    Status__c = 'Completed',
    Guest_Rating__c = 4.0,
    Notes__c = 'Full day cabana with beverage service included.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Fitness Center',
    Activity_Name__c = 'Morning Yoga Class',
    Activity_Date_Time__c = DateTime.now().addHours(12),
    Duration_Minutes__c = 60,
    Cost__c = 0.00,
    Location__c = 'Wellness Center - Yoga Studio',
    Status__c = 'Scheduled',
    Notes__c = 'Complimentary class for resort guests. Bring your own mat.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Spa Treatment',
    Activity_Name__c = 'Facial - Anti-Aging Treatment',
    Activity_Date_Time__c = DateTime.now().addDays(1).addHours(15),
    Duration_Minutes__c = 75,
    Cost__c = 180.00,
    Location__c = 'Serenity Spa - Treatment Room 1',
    Status__c = 'Scheduled',
    Notes__c = 'Guest has sensitive skin. Use hypoallergenic products.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Dining',
    Activity_Name__c = 'Sunset Beach BBQ',
    Activity_Date_Time__c = DateTime.now().addDays(1).addHours(18),
    Duration_Minutes__c = 120,
    Cost__c = 95.00,
    Location__c = 'Private Beach - South Pavilion',
    Status__c = 'Scheduled',
    Notes__c = 'Special event with live music. Vegetarian menu requested.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Entertainment',
    Activity_Name__c = 'Live Jazz Performance',
    Activity_Date_Time__c = DateTime.now().addDays(2).addHours(20),
    Duration_Minutes__c = 90,
    Cost__c = 0.00,
    Location__c = 'Sunset Lounge - Main Stage',
    Status__c = 'Scheduled',
    Notes__c = 'Complimentary for resort guests. Reserved VIP seating.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Concierge Service',
    Activity_Name__c = 'Restaurant Reservation - Off-Site',
    Activity_Date_Time__c = DateTime.now().addDays(3).addHours(19),
    Duration_Minutes__c = 30,
    Cost__c = 0.00,
    Location__c = 'Concierge Desk - Main Lobby',
    Status__c = 'Scheduled',
    Notes__c = 'Reservation at La Maison French Restaurant. Transportation arranged.'
));

activities.add(new Stay_Activity__c(
    Guest__c = guest.Id,
    Activity_Type__c = 'Room Service',
    Activity_Name__c = 'In-Room Breakfast',
    Activity_Date_Time__c = DateTime.now().addDays(-2).addHours(8),
    Duration_Minutes__c = 45,
    Cost__c = 42.00,
    Location__c = 'Room 305 - Ocean View Suite',
    Status__c = 'Completed',
    Guest_Rating__c = 4.5,
    Notes__c = 'Continental breakfast with fresh fruit platter. No nuts requested.'
));

insert activities;

System.debug('Created ' + activities.size() + ' Stay Activity records');
System.debug('Sample Activity IDs:');
for (Stay_Activity__c activity : activities) {
    System.debug('  - ' + activity.Activity_Name__c + ': ' + activity.Id);
}

System.debug('Data creation completed successfully!');