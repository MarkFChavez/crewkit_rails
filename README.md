# CrewKit

A desktop-first team management application for independent project managers to track multiple teams across different companies.

## Screenshots

### Waitlist
![Waitlist Screenshot](docs/waitlist-screenshot.png)

## Features

### Core Functionality
- **Team Management**: Create, edit, and archive teams (one team per company/client)
- **Team Members**: Add/remove members with role, contact info
- **Attendance Tracking**: Mark team members as present/absent/late with quick-entry interface
- **Hours Logging**: Track hours worked per team member with weekly/monthly totals
- **Dashboard**: Overview of all teams, today's attendance, and weekly hours
- **CSV Export**: Export attendance and hours data for reporting

### Technical Stack
- Rails 8.0.4
- SQLite database
- Tailwind CSS for responsive design
- Password-protected authentication
- Desktop-first, mobile-responsive interface

## Getting Started

### Prerequisites
- Ruby 3.2.2
- Rails 8.0.4
- SQLite3

### Installation

1. Install dependencies:
```bash
bundle install
```

2. Set up the database:
```bash
rails db:migrate
rails db:seed
```

3. Start the development server:
```bash
bin/dev
```

4. Visit http://localhost:3000

### Default Login Credentials
- **Email**: admin@example.com
- **Password**: password

## Usage Guide

### Dashboard
The dashboard provides an at-a-glance view of:
- Number of active teams and total members
- Today's attendance rate
- Hours logged this week
- Today's attendance details
- Quick access to all active teams

### Managing Teams
1. Navigate to **Teams** in the main menu
2. Click **Create New Team** to add a team
3. Fill in team name, company, and optional description
4. View team details to see all members
5. Archive inactive teams (they remain in the system but won't show in active lists)

### Managing Team Members
1. Go to a team's detail page
2. Click **Add Team Member**
3. Enter name, role, email, and phone number
4. Edit or remove members as needed

### Attendance Tracking

#### Quick Entry (Recommended)
1. Click **Quick Attendance Entry** from the dashboard
2. Select the date (defaults to today)
3. Mark each team member as Present/Late/Absent using radio buttons
4. Add optional notes per member
5. Click **Save Attendance**

#### View History
1. Navigate to **Attendance** in the main menu
2. Filter by team and date range
3. View attendance statistics and detailed history
4. Export to CSV for reporting

### Hours Logging
1. Navigate to **Hours** in the main menu
2. Enter hours worked per team member per day
3. Add deliverable notes describing what was worked on
4. View totals and trends
5. Export to CSV for billing/reporting

### CSV Export
- From Attendance or Hours pages, use the filter options to select your date range
- Click the export link to download a CSV file
- CSV includes team name, member details, dates, and all relevant data

## Data Structure

### Teams
- Name, Company, Description
- Active/Archived status
- Has many team members

### Team Members
- Name, Role, Email, Phone
- Belongs to one team
- Has attendance records and hours logs

### Attendance Records
- Date, Status (Present/Late/Absent), Notes
- One record per member per day
- Uniqueness constraint prevents duplicates

### Hours Logs
- Date, Hours worked, Deliverable notes
- One log per member per day
- Tracks daily work hours

## Development

### Running Tests
```bash
rails test
```

### Database Reset
```bash
rails db:reset
```

### Adding New Features
The application follows standard Rails MVC architecture:
- Models: `/app/models`
- Controllers: `/app/controllers`
- Views: `/app/views`
- Routes: `/config/routes.rb`

## Production Deployment

This application is designed for single-user local use. For production deployment:

1. Update database configuration for production database (PostgreSQL recommended)
2. Set up environment variables for secrets
3. Configure production web server
4. Enable HTTPS
5. Set up regular database backups

## License

This project is available for personal and commercial use.
