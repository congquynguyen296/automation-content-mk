CREATE TABLE content (
    id VARCHAR(50) PRIMARY KEY,
    status VARCHAR(50) NOT NULL,
    topic TEXT NOT NULL,
    title TEXT,
    hook TEXT,
    script TEXT,
    caption TEXT,
    hashtags TEXT[],
    template_key VARCHAR(100),
    target_duration_sec INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP WITH TIME ZONE,
    finalized_at TIMESTAMP WITH TIME ZONE,
    posted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE content_version (
    id SERIAL PRIMARY KEY,
    content_id VARCHAR(50) REFERENCES content(id),
    version INT NOT NULL,
    script TEXT,
    caption TEXT,
    hashtags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    reason TEXT
);

CREATE TABLE scene (
    id VARCHAR(50) PRIMARY KEY,
    content_id VARCHAR(50) REFERENCES content(id),
    scene_order INT NOT NULL,
    start_sec NUMERIC,
    end_sec NUMERIC,
    narration TEXT,
    visual_description TEXT,
    image_prompt TEXT,
    subtitle_text TEXT,
    version INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE asset (
    id VARCHAR(50) PRIMARY KEY,
    content_id VARCHAR(50) REFERENCES content(id),
    scene_id VARCHAR(50) REFERENCES scene(id),
    asset_type VARCHAR(50) NOT NULL,
    provider VARCHAR(50),
    provider_asset_id VARCHAR(255),
    storage_key VARCHAR(255),
    public_url TEXT,
    version INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    content_id VARCHAR(50) REFERENCES content(id),
    version INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    reviewer VARCHAR(100),
    comment TEXT,
    telegram_message_id VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE render_job (
    id VARCHAR(50) PRIMARY KEY,
    content_id VARCHAR(50) REFERENCES content(id),
    version INT NOT NULL,
    template_key VARCHAR(100),
    status VARCHAR(50) NOT NULL,
    input_manifest JSONB,
    output_storage_key VARCHAR(255),
    error_message TEXT,
    started_at TIMESTAMP WITH TIME ZONE,
    finished_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE workflow_error (
    id SERIAL PRIMARY KEY,
    content_id VARCHAR(50),
    workflow_name VARCHAR(255),
    node_name VARCHAR(255),
    error_code VARCHAR(50),
    error_message TEXT,
    execution_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP WITH TIME ZONE
);
