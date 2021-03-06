Feature: Specifying value generators using PhpSpecGeneratorExtension
    In order to specify value generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
    extensions:
        Pamil\PhpSpecGeneratorExtension\Extension: ~
    """

    Scenario: Positive matching value generator
        Given the spec file "spec/Pamil/ValueGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator1Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateValues('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/ValueGenerator1.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator1
{
    public function generateNames()
    {
        yield 'John';
        yield 'Paul';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching value generator
        Given the spec file "spec/Pamil/ValueGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator2Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerateValues('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/ValueGenerator2.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator2
{
    public function generateNames()
    {
        yield 'Benedict';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Positive matching value generator failing if generator has less elements than expected
        Given the spec file "spec/Pamil/ValueGenerator3Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator3Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateValues('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/ValueGenerator3.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator3
{
    public function generateNames()
    {
        yield 'John';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Expected 2 elements, but only 1 was generated'

    Scenario: Positive matching value generator failing if generator has unexpected elements
        Given the spec file "spec/Pamil/ValueGenerator4Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator4Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateValues('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/ValueGenerator4.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator4
{
    public function generateNames()
    {
        yield 'John';
        yield 'Benedict';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Element #1 was expected to be "Paul", but "Benedict" was given'

    Scenario: Negative matching value generator failing if generated elements matches the not expected ones
        Given the spec file "spec/Pamil/ValueGenerator5Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator5Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerateValues('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/ValueGenerator5.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator5
{
    public function generateNames()
    {
        yield 'John';
        yield 'Paul';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Generated values are the same as not expected values'

    Scenario: Positive matching value generator for not generating anything
        Given the spec file "spec/Pamil/ValueGenerator6Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator6Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateValues();
    }
}
    """
        And the class file "src/Pamil/ValueGenerator6.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator6
{
    public function generateNames()
    {
        return new \ArrayIterator([]);
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching value generator for not generating anything
        Given the spec file "spec/Pamil/ValueGenerator7Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator7Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerateValues();
    }
}
    """
        And the class file "src/Pamil/ValueGenerator7.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator7
{
    public function generateNames()
    {
        yield 'High Sparrow';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Positive matching value generator for not generating anything failing
        Given the spec file "spec/Pamil/ValueGenerator8Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class ValueGenerator8Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateValues();
    }
}
    """
        And the class file "src/Pamil/ValueGenerator8.php" contains:
    """
<?php

namespace Pamil;

class ValueGenerator8
{
    public function generateNames()
    {
        yield 'High Sparrow';
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Expected not to generate any elements, but the iterator is still valid'
