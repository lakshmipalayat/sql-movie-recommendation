# SQL Movie Recommendation System

Movie recommendation and rating analysis using SQL.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [SQL Queries](#sql-queries)
- [Key Insights](#key-insights)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

## Overview

This project demonstrates the power of SQL for analyzing movie data and generating personalized recommendations. Using a comprehensive movie database with ratings, genres, and user preferences, the system applies SQL queries to uncover patterns and deliver data-driven movie suggestions.

## Features

- ✅ **Movie Database Management** - Comprehensive movie catalog with metadata
- ✅ **Rating Analysis** - Analyze user ratings and review trends
- ✅ **Recommendation Engine** - SQL-based algorithm for personalized suggestions
- ✅ **Genre Analysis** - Explore movies by genre and popularity
- ✅ **User Preference Tracking** - Track and analyze user viewing patterns
- ✅ **Statistical Analysis** - Generate insights from rating distributions
- ✅ **Performance Optimization** - Efficient queries for large datasets

## Project Structure

```
sql-movie-recommendation/
├── README.md                 # Project documentation
├── database/
│   ├── schema.sql           # Database schema definition
│   └── sample_data.sql      # Sample data for testing
├── queries/
│   ├── recommendations.sql  # Core recommendation queries
│   ├── analysis.sql         # Analysis and statistics queries
│   └── reports.sql          # Report generation queries
└── docs/
    └── QUERIES.md           # Detailed query documentation
```

## Database Schema

### Core Tables

**movies**
- `movie_id` (PRIMARY KEY) - Unique movie identifier
- `title` - Movie title
- `release_year` - Year of release
- `genre` - Movie genre(s)
- `duration` - Movie duration in minutes
- `director` - Director name
- `description` - Plot summary

**ratings**
- `rating_id` (PRIMARY KEY) - Unique rating identifier
- `movie_id` (FOREIGN KEY) - Reference to movies table
- `user_id` (FOREIGN KEY) - Reference to users table
- `rating` - Rating value (1-5 or 1-10)
- `review` - User review text
- `timestamp` - Rating timestamp

**users**
- `user_id` (PRIMARY KEY) - Unique user identifier
- `username` - Username
- `email` - Email address
- `join_date` - Account creation date

**genres**
- `genre_id` (PRIMARY KEY) - Genre identifier
- `genre_name` - Genre name
- `description` - Genre description

## Setup Instructions

### Prerequisites
- MySQL/PostgreSQL/SQL Server (or your preferred SQL database)
- SQL client or command-line interface
- Sample dataset (included)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/lakshmipalayat/sql-movie-recommendation.git
   cd sql-movie-recommendation
   ```

2. **Create the database**
   ```bash
   mysql -u root -p < database/schema.sql
   ```

3. **Load sample data**
   ```bash
   mysql -u root -p movie_db < database/sample_data.sql
   ```

4. **Verify installation**
   ```sql
   SELECT COUNT(*) FROM movies;
   SELECT COUNT(*) FROM ratings;
   SELECT COUNT(*) FROM users;
   ```

## Usage

### Basic Recommendation Query

```sql
-- Get top 5 movie recommendations for a user based on similar ratings
SELECT DISTINCT m.movie_id, m.title, AVG(r.rating) as avg_rating
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
WHERE m.genre IN (
    SELECT DISTINCT genre FROM movies 
    WHERE movie_id IN (
        SELECT movie_id FROM ratings 
        WHERE user_id = 1 AND rating >= 4
    )
)
GROUP BY m.movie_id, m.title
ORDER BY avg_rating DESC
LIMIT 5;
```

### Find Similar Movies

```sql
-- Find movies similar to a given movie
SELECT DISTINCT m2.movie_id, m2.title, COUNT(*) as similarity_score
FROM movies m1
JOIN movies m2 ON m1.genre = m2.genre AND m1.movie_id != m2.movie_id
WHERE m1.movie_id = 1
GROUP BY m2.movie_id, m2.title
ORDER BY similarity_score DESC
LIMIT 10;
```

## SQL Queries

The project includes comprehensive SQL queries for:

- **Recommendation Generation** - Personalized movie suggestions
- **Rating Distribution Analysis** - Statistical insights
- **User Preference Profiling** - Understanding viewer tastes
- **Trending Movies** - Popular and rising movies
- **Genre Performance** - Genre-specific analytics
- **User Similarity** - Finding users with similar tastes

See `docs/QUERIES.md` for detailed query documentation and examples.

## Key Insights

### Typical Analysis Results

- Average user rating distribution and patterns
- Most recommended movie combinations
- Genre popularity trends
- User engagement metrics
- Rating correlation analysis

*Note: Results will vary based on your dataset*

## Technologies Used

- **SQL** - Core query language
- **MySQL/PostgreSQL** - Database management systems
- **Database Design** - Schema optimization and normalization
- **Query Optimization** - Performance tuning and indexing

## Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add improvement'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

### Areas for Contribution

- Additional recommendation algorithms
- Performance optimization queries
- Extended analysis queries
- Documentation improvements
- Test cases and data validation

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Lakshmi Palayat**
- GitHub: [@lakshmipalayat](https://github.com/lakshmipalayat)
- Email: [Your Email]

---

## Getting Help

If you encounter any issues or have questions:

1. Check the documentation in `docs/QUERIES.md`
2. Review the sample queries in `queries/`
3. Open an issue on GitHub
4. Feel free to contribute improvements

**Happy analyzing! 🎬📊**
