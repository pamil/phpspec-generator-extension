Feature: Specifying infinite key generators using PhpSpecGeneratorExtension
    In order to specify infinite key generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
extensions:
    - Pamil\PhpSpecGeneratorExtension\Extension
    """

    Scenario: Positive matching infinite key generator
        Given the spec file "spec/Pamil/InfiniteKeyGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteKeyGenerator1Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldGenerateKeys('John 1', 'John 2', 'John 3');
    }
}
    """
        And the class file "src/Pamil/InfiniteKeyGenerator1.php" contains:
    """
<?php

namespace Pamil;

class InfiniteKeyGenerator1
{
    public function generateNames()
    {
        for ($i = 1; true; ++$i) {
            yield sprintf('John %d', $i) => true;
        }
    }
}
    """
        When I run phpspec
        Then the suite should pass

    Scenario: Negative matching infinite key generator
        Given the spec file "spec/Pamil/InfiniteKeyGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class InfiniteKeyGenerator2Spec extends ObjectBehavior
{
    function it_generates_not_so_random_names()
    {
        $this->generateNames()->shouldNotGenerateKeys('Anakin', 'Luke', 'Yoda');
    }
}
    """
        And the class file "src/Pamil/InfiniteKeyGenerator2.php" contains:
    """
<?php

namespace Pamil;

class InfiniteKeyGenerator2
{
    public function generateNames()
    {
        for ($i = 2; true; ++$i) {
            yield sprintf('John %d', $i) => true;
        }
    }
}
    """
        When I run phpspec
        Then the suite should pass
