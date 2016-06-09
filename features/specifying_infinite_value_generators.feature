Feature: Specifying infinite value generators using PhpSpecGeneratorExtension
    In order to specify infinite value generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
extensions:
    - Pamil\PhpSpecGeneratorExtension\Extension
    """

    Scenario: Positive matching infinite value generator
        Given the spec file "spec/Pamil/InfiniteValueGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteValueGenerator1Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldGenerateValues('John 1', 'John 2', 'John 3');
    }
}
    """
        And the class file "src/Pamil/InfiniteValueGenerator1.php" contains:
    """
<?php

namespace Pamil;

class InfiniteValueGenerator1
{
    public function generateNames()
    {
        for ($i = 1; true; ++$i) {
            yield sprintf('John %d', $i);
        }
    }
}
    """
        When I run phpspec
        Then the suite should pass

    Scenario: Negative matching infinite value generator
        Given the spec file "spec/Pamil/InfiniteValueGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteValueGenerator2Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldNotGenerateValues('Anakin', 'Luke', 'Yoda');
    }
}
    """
        And the class file "src/Pamil/InfiniteValueGenerator2.php" contains:
    """
<?php

namespace Pamil;

class InfiniteValueGenerator2
{
    public function generateNames()
    {
        for ($i = 2; true; ++$i) {
            yield sprintf('John %d', $i);
        }
    }
}
    """
        When I run phpspec
        Then the suite should pass
