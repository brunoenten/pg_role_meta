# [pg_role_meta: Key-Value Store for PostgreSQL Roles](https://github.com/brunoenten/pg_role_meta)

`pg_role_meta` is a PostgreSQL extension that introduces a key-value store mechanism for PostgreSQL roles. This feature allows for the association of custom metadata with database roles, facilitating enhanced role management and customization.

## Features

- **Custom Metadata Association**: Attach key-value pairs to PostgreSQL roles for storing additional information.
- **Enhanced Role Management**: Utilize metadata to manage roles more effectively within the database.
- **Seamless Integration**: Operate entirely within PostgreSQL, eliminating the need for external tools.

## Prerequisites

Before installing `pg_role_meta`, ensure you have the following:

- PostgreSQL 9.6 or higher

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/brunoenten/pg_role_meta.git
   ```

2. **Navigate to the Directory**:

   ```bash
   cd pg_role_meta
   ```

3. **Build and Install the Extension**:

   ```bash
   make
   sudo make install
   ```

4. **Load the Extension in PostgreSQL**:

   ```sql
   CREATE EXTENSION role_meta;
   ```

## Usage

After installation, you can begin associating metadata with roles. For example, to add metadata to a role:

```sql
-- Add metadata to a role
SELECT role_meta.set_to_role('role_name', 'key', 'value');

-- Retrieve metadata for a role
SELECT role_meta.get_from_role('role_name', 'key');

-- Add metadata to current user
SELECT role_meta.set_to_current_user('key', 'value');

-- Retrieve metadata for current user
SELECT role_meta.get_from_current_user('key');

```

Replace `'role_name'`, `'key'`, and `'value'` with your specific role name and metadata details.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your enhancements or bug fixes.

## License

This project is licensed under the GPL-3.0 License. See the [LICENSE.txt](LICENSE.txt) file for details.

## Acknowledgments

Special thanks to the PostgreSQL community for their continuous support and development of the database system.

---

*Note: This extension is a community-driven project and is not officially supported by the PostgreSQL Global Development Group.* 
