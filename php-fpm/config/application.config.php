<?php
namespace Omeka;

return [
    'modules' => [
        'Laminas\Form',
        'Laminas\I18n',
        'Laminas\Mvc\I18n',
        'Laminas\Mvc\Plugin\Identity',
        'Laminas\Navigation',
        'Laminas\Router',
        'Laminas\ZendFrameworkBridge',
        'Omeka',
    ],
    'module_listener_options' => [
        'module_paths' => [
            'Omeka' => OMEKA_PATH . '/application',
            OMEKA_PATH . '/modules',
        ],
        'config_glob_paths' => [
            OMEKA_PATH . '/config/local.config.php',
        ],
    ],
    'service_manager' => [
        'factories' => [
            'Omeka\Connection' => Service\ConnectionFactory::class,
            'Omeka\ModuleManager' => Service\ModuleManagerFactory::class,
            'Omeka\Status' => Service\StatusFactory::class,
        ],
    ],
    'connection' => [
        'user' => $_ENV['DATABASE_USER'],
        'password' => $_ENV['DATABASE_PASSWORD'],
        'dbname' => $_ENV['DATABASE_NAME'],
        'host' => $_ENV['DATABASE_HOST'],
    ]
];
