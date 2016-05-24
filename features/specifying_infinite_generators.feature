Feature: Specifying infinite generators using PhpSpecGeneratorExtension
    In order to specify infinite generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
extensions:
    - Pamil\PhpSpecGeneratorExtension\Extension
    """

    Scenario: Positive matching infinite generator
        Given the spec file "spec/Pamil/InfiniteGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteGenerator1Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldGenerate(['John 1', 'John 2', 'John 3']);
    }
}
    """
        And the class file "src/Pamil/InfiniteGenerator1.php" contains:
    """
<?php

namespace Pamil;

class InfiniteGenerator1
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

    Scenario: Negative matching infinite generator
        Given the spec file "spec/Pamil/InfiniteGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteGenerator2Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldNotGenerate(['Anakin 1', 'Luke 2', 'R2D2']);
    }
}
    """
        And the class file "src/Pamil/InfiniteGenerator2.php" contains:
    """
<?php

namespace Pamil;

class InfiniteGenerator2
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
