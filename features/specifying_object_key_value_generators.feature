Feature: Specifying object key value generators using PhpSpecGeneratorExtension
    In order to specify object key value generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
extensions:
    - Pamil\PhpSpecGeneratorExtension\Extension
    """

    Scenario: Positive matching object key value generator
        Given the spec file "spec/Pamil/ObjectKeyValueGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ObjectKeyValueGenerator1Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $stdClass = new \stdClass();

        $this->generate($stdClass)->shouldGenerate([$stdClass, 1], [$stdClass, 2]);
    }
}
    """
        And the class file "src/Pamil/ObjectKeyValueGenerator1.php" contains:
    """
<?php

namespace Pamil;

class ObjectKeyValueGenerator1
{
    public function generate(\stdClass $object)
    {
        yield $object => 1;
        yield $object => 2;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching object key value generator
        Given the spec file "spec/Pamil/ObjectKeyValueGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ObjectKeyValueGenerator2Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generate()->shouldNotGenerate([new \stdClass(), 1]);
    }
}
    """
        And the class file "src/Pamil/ObjectKeyValueGenerator2.php" contains:
    """
<?php

namespace Pamil;

class ObjectKeyValueGenerator2
{
    public function generate()
    {
        yield (new \stdClass()) => 1;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass
