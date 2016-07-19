<?php

namespace Pamil\PhpSpecGeneratorExtension;

use PhpSpec\ServiceContainer;
use PhpSpec\ServiceContainer\IndexedServiceContainer;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class Extension implements \PhpSpec\Extension
{
    /**
     * {@inheritdoc}
     */
    public function load(ServiceContainer $container, array $params)
    {
        if (!$container instanceof IndexedServiceContainer) {
            throw new \InvalidArgumentException(sprintf(
                'Container passed from PhpSpec must be an instance of "%s"',
                IndexedServiceContainer::class
            ));
        }

        $container->define('pamil.matchers.generate', function (IndexedServiceContainer $c) {
            return new Matcher\GenerateMatcher($c->get('formatter.presenter'));
        }, ['matchers']);

        $container->define('pamil.matchers.generate_values', function (IndexedServiceContainer $c) {
            return new Matcher\GenerateValuesMatcher($c->get('formatter.presenter'));
        }, ['matchers']);

        $container->define('pamil.matchers.generate_keys', function (IndexedServiceContainer $c) {
            return new Matcher\GenerateKeysMatcher($c->get('formatter.presenter'));
        }, ['matchers']);
    }
}
