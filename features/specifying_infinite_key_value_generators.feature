Feature: Specifying infinite key value generators using PhpSpecGeneratorExtension
    In order to specify infinite key value generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
    extensions:
        Pamil\PhpSpecGeneratorExtension\Extension: ~
    """

    Scenario: Positive matching infinite key value generator
        Given the spec file "spec/Pamil/InfiniteKeyValueGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteKeyValueGenerator1Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldGenerate(['John' => 1], ['John' => 2], ['John' => 3]);
    }
}
    """
        And the class file "src/Pamil/InfiniteKeyValueGenerator1.php" contains:
    """
<?php

namespace Pamil;

class InfiniteKeyValueGenerator1
{
    public function generateNames()
    {
        for ($i = 1; true; ++$i) {
            yield 'John' => $i;
        }
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching infinite key value generator
        Given the spec file "spec/Pamil/InfiniteKeyValueGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteKeyValueGenerator2Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldNotGenerate(['Anakin' => 1], ['Luke' => 2], ['Yoda' => 3]);
    }
}
    """
        And the class file "src/Pamil/InfiniteKeyValueGenerator2.php" contains:
    """
<?php

namespace Pamil;

class InfiniteKeyValueGenerator2
{
    public function generateNames()
    {
        for ($i = 1; true; ++$i) {
            yield 'Anakin' => $i;
        }
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass
