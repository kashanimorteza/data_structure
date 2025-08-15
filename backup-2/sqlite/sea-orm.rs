use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        // Create all tables
        let sql_config = r#"
            CREATE TABLE config (
                id INTEGER PRIMARY KEY NOT NULL,
                name VARCHAR(255),
                timeZone VARCHAR(255),
                path_api VARCHAR(255),
                path_gui VARCHAR(255),
                webapi_title VARCHAR(255),
                webapi_description VARCHAR(255),
                webapi_version VARCHAR(255),
                webapi_openapi_url VARCHAR(255),
                webapi_docs_url VARCHAR(255),
                webapi_redoc_url VARCHAR(255),
                webapi_key VARCHAR(255),
                webapi_host VARCHAR(255),
                webapi_port INTEGER,
                webapi_workers INTEGER,
                nginx_api_host VARCHAR(255),
                nginx_api_port INTEGER,
                nginx_api_key VARCHAR(255),
                nginx_gui_host VARCHAR(255),
                nginx_gui_port INTEGER,
                nginx_gui_key VARCHAR(255),
                git_email VARCHAR(255),
                git_name VARCHAR(255),
                git_key VARCHAR(255),
                hotspod_ssid VARCHAR(255),
                hotspod_ip VARCHAR(255),
                hotspod_pass VARCHAR(255),
                wifi_ssid VARCHAR(255),
                wifi_ip VARCHAR(255),
                wifi_pass VARCHAR(255),
                debug BOOLEAN,
                log BOOLEAN,
                verbose BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_config).await?;

        let sql_device = r#"
            CREATE TABLE device (
                id INTEGER PRIMARY KEY NOT NULL,
                zone_id INTEGER NOT NULL,
                port_id INTEGER NOT NULL,
                power_id INTEGER NOT NULL,
                command_id INTEGER NOT NULL,
                value INTEGER NOT NULL,
                tune INTEGER NOT NULL,
                date TIME,
                address VARCHAR(255),
                name VARCHAR(255),
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_device).await?;

        let sql_device_command = r#"
            CREATE TABLE device_command (
                id INTEGER PRIMARY KEY NOT NULL,
                device_id INTEGER NOT NULL,
                name VARCHAR(255),
                value_from INTEGER,
                value_to INTEGER,
                delay INTEGER,
                description VARCHAR(255),
                reload BOOLEAN,
                enable BOOLEAN,
                type VARCHAR(7) NOT NULL
            );
        "#;
        manager.get_connection().execute_unprepared(sql_device_command).await?;

        let sql_log = r#"
            CREATE TABLE log (
                id INTEGER PRIMARY KEY NOT NULL,
                date VARCHAR(255),
                name VARCHAR(255),
                status BOOLEAN,
                data VARCHAR(255)
            );
        "#;
        manager.get_connection().execute_unprepared(sql_log).await?;

        let sql_port = r#"
            CREATE TABLE port (
                id INTEGER PRIMARY KEY NOT NULL,
                user_id INTEGER NOT NULL,
                name VARCHAR(255),
                pin INTEGER,
                port INTEGER,
                value INTEGER,
                description VARCHAR(255),
                enable BOOLEAN,
                protocol VARCHAR(8) NOT NULL,
                type VARCHAR(4) NOT NULL
            );
        "#;
        manager.get_connection().execute_unprepared(sql_port).await?;

        let sql_timer = r#"
            CREATE TABLE timer (
                id INTEGER PRIMARY KEY NOT NULL,
                user_id INTEGER NOT NULL,
                name VARCHAR(255),
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_timer).await?;

        let sql_timer_device = r#"
            CREATE TABLE timer_device (
                id INTEGER PRIMARY KEY NOT NULL,
                timer_id INTEGER NOT NULL,
                device_id INTEGER NOT NULL,
                command_id INTEGER NOT NULL,
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_timer_device).await?;

        let sql_timer_item = r#"
            CREATE TABLE timer_item (
                id INTEGER PRIMARY KEY NOT NULL,
                timer_id INTEGER NOT NULL,
                name VARCHAR(255),
                value_from VARCHAR(255),
                value_to VARCHAR(255),
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_timer_item).await?;

        let sql_timer_limit = r#"
            CREATE TABLE timer_limit (
                id INTEGER PRIMARY KEY NOT NULL,
                device_id INTEGER NOT NULL,
                command_from_id INTEGER NOT NULL,
                command_to_id INTEGER NOT NULL,
                value INTEGER NOT NULL,
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_timer_limit).await?;

        let sql_user = r#"
            CREATE TABLE user (
                id INTEGER PRIMARY KEY NOT NULL,
                name VARCHAR(255),
                username VARCHAR(255),
                password VARCHAR(255),
                key VARCHAR(255),
                email VARCHAR(255),
                phone VARCHAR(255),
                tg_id VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_user).await?;

        let sql_zone = r#"
            CREATE TABLE zone (
                id INTEGER PRIMARY KEY NOT NULL,
                user_id INTEGER NOT NULL,
                name VARCHAR(255),
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_zone).await?;

        let sql_zone_command = r#"
            CREATE TABLE zone_command (
                id INTEGER PRIMARY KEY NOT NULL,
                zone_id INTEGER NOT NULL,
                name VARCHAR(255),
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_zone_command).await?;

        let sql_zone_command_action = r#"
            CREATE TABLE zone_command_action (
                id INTEGER PRIMARY KEY NOT NULL,
                name VARCHAR(255),
                zone_command_id INTEGER NOT NULL,
                device_id INTEGER NOT NULL,
                command_id INTEGER,
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_zone_command_action).await?;

        let sql_zone_command_if = r#"
            CREATE TABLE zone_command_if (
                id INTEGER PRIMARY KEY NOT NULL,
                name VARCHAR(255),
                zone_command_id INTEGER NOT NULL,
                device_id INTEGER NOT NULL,
                command_id INTEGER NOT NULL,
                description VARCHAR(255),
                enable BOOLEAN
            );
        "#;
        manager.get_connection().execute_unprepared(sql_zone_command_if).await?;

        Ok(())
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        // Drop all tables in reverse order
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS zone_command_if;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS zone_command_action;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS zone_command;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS zone;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS user;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS timer_limit;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS timer_item;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS timer_device;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS timer;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS port;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS log;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS device_command;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS device;").await?;
        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS config;").await?;
        Ok(())
    }
}