# Create default user
user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

puts "Created user: #{user.email}"

# Filipino names database
filipino_first_names = [
  "Maria", "Jose", "Juan", "Antonio", "Pedro", "Rosa", "Francisco", "Ana", "Manuel", "Carmen",
  "Luis", "Josefa", "Jesus", "Teresa", "Miguel", "Luz", "Rafael", "Cristina", "Gabriel", "Isabella",
  "Ramon", "Sofia", "Carlos", "Elena", "Fernando", "Patricia", "Roberto", "Michelle", "Diego", "Andrea",
  "Marco", "Katrina", "Paolo", "Bianca", "Lorenzo", "Angelica", "Emmanuel", "Nicole", "Angelo", "Jasmine",
  "Ricardo", "Mariana", "Enrique", "Victoria", "Raphael", "Gabriella", "Sebastian", "Samantha", "Lucas", "Daniela"
]

filipino_last_names = [
  "Reyes", "Santos", "Cruz", "Bautista", "Garcia", "Fernandez", "Gonzales", "Mendoza", "Torres", "Ramos",
  "Flores", "Castillo", "Rivera", "Aquino", "Del Rosario", "Villanueva", "Mercado", "Santiago", "Chavez", "Pascual",
  "Dela Cruz", "Martinez", "Lopez", "Morales", "Hernandez", "Soriano", "Valdez", "Castro", "Diaz", "Domingo",
  "Tan", "Lim", "Sy", "Ong", "Chua", "Go", "Lee", "Ng", "Wong", "Chan"
]

roles = [
  "Senior Developer", "Junior Developer", "Frontend Developer", "Backend Developer", "Full Stack Developer",
  "UI/UX Designer", "Product Designer", "Graphic Designer", "QA Engineer", "DevOps Engineer",
  "Project Manager", "Scrum Master", "Business Analyst", "Data Analyst", "System Administrator",
  "Technical Lead", "Team Lead", "Software Engineer", "Mobile Developer", "Security Engineer"
]

companies = [
  "TechHub Manila", "InnovatePH Solutions", "Digital Minds Inc", "CodeCraft Philippines", "ByteWorks Corp",
  "CloudNine Technologies", "AppForge Manila", "DataStream Solutions", "NextGen Systems", "WebSphere PH",
  "Innovatech Corp", "Smart Solutions Inc", "Digital Innovations", "TechSavvy Philippines", "Cyber Systems",
  "BrightCode Technologies", "AgileWorks Manila", "DevHub Philippines", "ProTech Solutions", "FutureSoft Inc"
]

team_types = [
  "Web Development", "Mobile Development", "Quality Assurance", "DevOps", "Design",
  "Backend Engineering", "Frontend Engineering", "Data Analytics", "Product Management", "Infrastructure",
  "Security", "Research & Development", "Platform Engineering", "Customer Solutions", "Integration",
  "Cloud Services", "API Development", "Technical Support", "Innovation Lab", "Digital Transformation"
]

# Create 20 teams
teams = []
20.times do |i|
  team_name = "#{team_types.sample} Team"
  company = companies.sample

  team = Team.find_or_create_by!(name: "#{team_name} #{i + 1}", company: company) do |t|
    descriptions = [
      "Responsible for developing and maintaining core platform features",
      "Focused on delivering high-quality user experiences",
      "Building scalable and reliable systems",
      "Driving innovation through technology",
      "Creating seamless digital solutions for clients",
      "Ensuring system reliability and performance",
      "Developing cutting-edge applications",
      "Managing enterprise-level projects"
    ]
    t.description = descriptions.sample
    t.active = i < 18 # Make 18 active, 2 archived for variety
  end

  teams << team
end

puts "Created #{Team.count} teams"

# Create team members for each team
teams.each do |team|
  member_count = rand(5..10)

  member_count.times do |i|
    first_name = filipino_first_names.sample
    last_name = filipino_last_names.sample
    full_name = "#{first_name} #{last_name}"
    email = "#{first_name.downcase}.#{last_name.downcase.gsub(' ', '')}@#{team.company.downcase.gsub(' ', '').gsub(/[^a-z0-9]/, '')}.com"
    phone = "+63 9#{rand(100000000..999999999)}"
    role = roles.sample

    TeamMember.find_or_create_by!(name: full_name, team: team) do |m|
      m.role = role
      m.email = email
      m.phone = phone
    end
  end
end

puts "Created #{TeamMember.count} team members"

# Create sample attendance records for the past 2 weeks
today = Date.today
two_weeks_ago = today - 14.days

attendance_notes = [
  "On time", "Late due to traffic", "Work from home", "Half day - medical appointment",
  "Early arrival", "Overtime yesterday", "Team meeting", nil, nil, nil
]

TeamMember.all.each do |member|
  (two_weeks_ago..today).each do |date|
    # Skip weekends
    next if date.saturday? || date.sunday?

    # Most people are present, some are late, few are absent
    status_weights = { present: 0.85, late: 0.10, absent: 0.05 }
    status = status_weights.max_by { |_, weight| rand ** (1.0 / weight) }.first

    AttendanceRecord.find_or_create_by!(team_member: member, record_date: date) do |record|
      record.status = status
      record.notes = attendance_notes.sample if [:late, :absent].include?(status) || rand < 0.2
    end
  end
end

puts "Created #{AttendanceRecord.count} attendance records"

# Create sample hours logs
deliverable_tasks = [
  "Implemented new user authentication flow",
  "Fixed critical bug in payment processing",
  "Designed mockups for mobile app redesign",
  "Conducted code review for team members",
  "Updated API documentation",
  "Optimized database queries for better performance",
  "Created unit tests for core features",
  "Attended client meeting and gathered requirements",
  "Deployed new features to production",
  "Refactored legacy code for maintainability",
  "Integrated third-party API",
  "Resolved customer support tickets",
  "Participated in sprint planning",
  "Worked on UI improvements",
  "Set up CI/CD pipeline",
  "Performance testing and optimization",
  "Security audit and fixes",
  "Collaborated with design team on new features",
  "Mentored junior developers",
  "Research and development for new tech stack"
]

TeamMember.all.each do |member|
  (two_weeks_ago..today).each do |date|
    # Skip weekends
    next if date.saturday? || date.sunday?

    # Only create hours log if attendance was present or late
    attendance = AttendanceRecord.find_by(team_member: member, record_date: date)
    next unless attendance && [:present, :late].include?(attendance.status.to_sym)

    HoursLog.find_or_create_by!(team_member: member, log_date: date) do |log|
      # Most people work 8 hours, some work more or less
      hours_options = [7, 7.5, 8, 8, 8, 8.5, 9, 9.5, 10]
      log.hours = hours_options.sample
      log.deliverable_notes = deliverable_tasks.sample(rand(1..3)).join(". ") if rand < 0.7
    end
  end
end

puts "Created #{HoursLog.count} hours logs"
puts "\n✅ Seed data complete!"
puts "📊 Summary:"
puts "  - #{User.count} user(s)"
puts "  - #{Team.count} teams"
puts "  - #{TeamMember.count} team members"
puts "  - #{AttendanceRecord.count} attendance records"
puts "  - #{HoursLog.count} hours logs"
