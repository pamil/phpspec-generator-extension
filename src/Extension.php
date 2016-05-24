<?php

namespace Pamil\PhpSpecGeneratorExtension;

use PhpSpec\Extension\ExtensionInterface;
use PhpSpec\ServiceContainer;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class Extension implements ExtensionInterface
{
    /**
     * {@inheritdoc}
     */
    public function load(ServiceContainer $container)
    {
        $container->set('matchers.generate', function (ServiceContainer $c) {
            return new Matcher\GenerateMatcher($c->get('formatter.presenter'));
        });
    }
}
