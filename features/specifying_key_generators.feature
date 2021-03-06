Feature: Specifying key generators using PhpSpecGeneratorExtension
    In order to specify key generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
    extensions:
        Pamil\PhpSpecGeneratorExtension\Extension: ~
    """

    Scenario: Positive matching key generator
        Given the spec file "spec/Pamil/KeyGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator1Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateKeys('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/KeyGenerator1.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator1
{
    public function generateNames()
    {
        yield 'John' => true;
        yield 'Paul' => true;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching key generator
        Given the spec file "spec/Pamil/KeyGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator2Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerateKeys('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/KeyGenerator2.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator2
{
    public function generateNames()
    {
        yield 'Benedict' => true;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Positive matching key generator failing if generator has less elements than expected
        Given the spec file "spec/Pamil/KeyGenerator3Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator3Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateKeys('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/KeyGenerator3.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator3
{
    public function generateNames()
    {
        yield 'John' => true;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Expected 2 elements, but only 1 was generated'

    Scenario: Positive matching key generator failing if generator has unexpected elements
        Given the spec file "spec/Pamil/KeyGenerator4Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator4Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateKeys('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/KeyGenerator4.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator4
{
    public function generateNames()
    {
        yield 'John' => true;
        yield 'Benedict' => true;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Element #1 was expected to have key "Paul", but "Benedict" was given'

    Scenario: Negative matching key generator failing if generated elements matches the not expected ones
        Given the spec file "spec/Pamil/KeyGenerator5Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator5Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerateKeys('John', 'Paul');
    }
}
    """
        And the class file "src/Pamil/KeyGenerator5.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator5
{
    public function generateNames()
    {
        yield 'John' => true;
        yield 'Paul' => true;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Generated keys are the same as not expected keys'

    Scenario: Positive matching key generator for not generating anything
        Given the spec file "spec/Pamil/KeyGenerator6Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator6Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateKeys();
    }
}
    """
        And the class file "src/Pamil/KeyGenerator6.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator6
{
    public function generateNames()
    {
        return new \ArrayIterator([]);
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching key generator for not generating anything
        Given the spec file "spec/Pamil/KeyGenerator7Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator7Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerateKeys();
    }
}
    """
        And the class file "src/Pamil/KeyGenerator7.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator7
{
    public function generateNames()
    {
        yield 'High Sparrow' => 42;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Positive matching key generator for not generating anything failing
        Given the spec file "spec/Pamil/KeyGenerator8Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyGenerator8Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerateKeys();
    }
}
    """
        And the class file "src/Pamil/KeyGenerator8.php" contains:
    """
<?php

namespace Pamil;

class KeyGenerator8
{
    public function generateNames()
    {
        yield 'High Sparrow' => 42;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Expected not to generate any elements, but the iterator is still valid'
