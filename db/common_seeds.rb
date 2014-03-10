include SeedsHelpers

### Non Internationlized Records ###

# load the roles
[
    {name: 'admin'},
    {name: 'agent'},
    {name: 'agent_admin'},
].each do |role|
  r = Role.new(role)
  r.save!
end

#Create reports and internationalize their names
[
    {name: 'Trips Created', description: 'Displays a chart showing the number of trips created each day.', view_name: 'generic_report', class_name: 'TripsCreatedByDayReport', active: 1},
    {name: 'Trips Scheduled', description: 'Displays a chart showing the number of trips scheduled for each day.', view_name: 'generic_report', class_name: 'TripsScheduledByDayReport', active: 1},
    {name: 'Failed Trips', description: 'Displays a report describing the trips that failed.', view_name: 'trips_report', class_name: 'InvalidTripsReport', active: 1},
    {name: 'Rejected Trips', description: 'Displays a report showing trips that were rejected by a user.', view_name: 'trips_report', class_name: 'RejectedTripsReport', active: 1}
].each do |rep|
  Report.create!(rep)
  Translation.create!(key: rep[:class_name], locale: :en, value: rep[:class_name])
  Translation.create!(key: rep[:class_name], locale: :es, value: "[es]#{rep[:class_name]}[/es]")
end

#Create Admin User
User.find_by_email(admin[:email]).destroy rescue nil
admin = {first_name: 'sys', last_name: 'admin', email: 'email@camsys.com'}
u = User.create! admin.merge({password: 'welcome1'})
up = UserProfile.new
up.user = u
up.save!
u.add_role 'admin'
u.save!

### Internationalized Records ###

[
  # load the trip statuses
    { klass: TripStatus, active: 1, name: 'New', code: 'trip_status_new'},
    { klass: TripStatus, active: 1, name: 'In Progress',code: 'trip_status_in_progress'},
    { klass: TripStatus, active: 1, name: 'Completed',code: 'trip_status_completed'},
    { klass: TripStatus, active: 1, name: 'Errored',code: 'trip_status_errored'},
# load the modes and internationalize their names
    { klass: Mode, active: 1, name: 'Transit', code: 'mode_transit'},
    { klass: Mode, active: 1, name: 'Paratransit', code: 'mode_paratransit'},
    { klass: Mode, active: 1, name: 'Taxi', code: 'mode_taxi'},
    { klass: Mode, active: 1, name: 'Rideshare', code: 'mode_rideshare'},
    #Create relationship statuses
    { klass: RelationshipStatus, name: 'Requested', code: 'relationship_status_requested'},
    { klass: RelationshipStatus, name: 'Pending', code: 'relationship_status_pending'},
    { klass: RelationshipStatus, name: 'Confirmed', code: 'relationship_status_confirmed'},
    { klass: RelationshipStatus, name: 'Denied', code: 'relationship_status_denied'},
    { klass: RelationshipStatus, name: 'Revoked', code: 'relationship_status_revoked'},
    { klass: RelationshipStatus, name: 'Hidden', code: 'relationship_status_hidden'}
].each do |record|
  structured_hash = structure_records_from_flat_hash record
  build_internationalized_records structured_hash
end

#Set up the common CMS tags with non-branded defaults
text = <<EOT
<h2 style="text-align: justify;">1-Click helps you find options to get from here to there, using public transit,
 door-to-door services, and specialized transportation.  Give it a try, and
 <a href="mailto://OneClick@camsys.com">tell us</a> what you think.</h2>
EOT
Translation.create!(:key =>'home-top_html', :locale => :en, :value => text)
Translation.create!(:key =>'home-top-logged-in_html', :locale => :en, :value => text)
text = <<EOT
1-Click was funded by the
 <a href="http://www.fta.dot.gov/grants/13094_13528.html" target=_blank>Veterans Transportation
 Community Living Initiative</a>.
EOT
Translation.create!(:key =>'home-bottom-left-logged-in_html', :locale => :en, :value => text)
Translation.create!(:key =>'home-bottom-left_html', :locale => :en, :value => text)
text = <<EOT
<span style="float: right;">1-Click is brought to you by 
<a href="http://www.camsys.com/" target=_blank>Cambridge Systematics, Inc.</a>.</span>
EOT
Translation.create!(:key =>'home-bottom-right-logged-in_html', :locale => :en, :value => text)
Translation.create!(:key =>'home-bottom-right_html', :locale => :en, :value => text)
text = <<EOT
Tell us about your trip.  The more information you give us, the more options we can find!
EOT
Translation.create(:key =>'plan-a-trip_html', :locale => :en, :value => text)
Translation.create(:key => 'home-bottom-center_html', locale: :en, complete: true)
Translation.create(:key => 'home-bottom-center-logged-in_html', locale: :en, complete: true)

text = "In order to personalize the trip results further, would you please tell us about the programs you currently participate in?"
Translation.create(:key => 'gather-program-info_html', locale: :en, complete: true, value: text)

text= "Registering for ARC One-Click allows you to save your eligibility and needs information for planning future trips, as well as the ability to save and reuse trips, set up a travel buddy, and more."
Translation.create(:key => 'registration-reasoning', locale: :en, complete: true, value: text)