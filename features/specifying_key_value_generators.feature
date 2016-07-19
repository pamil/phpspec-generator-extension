Feature: Specifying key value generators using PhpSpecGeneratorExtension
    In order to specify key value generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
    extensions:
        Pamil\PhpSpecGeneratorExtension\Extension: ~
    """

    Scenario: Positive matching key value generator
        Given the spec file "spec/Pamil/KeyValueGenerator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator1Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator1.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator1
{
    public function generateNames()
    {
        yield 'John' => 1;
        yield 'Paul' => 2;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching key value generator (invalid key)
        Given the spec file "spec/Pamil/KeyValueGenerator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator2Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator2.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator2
{
    public function generateNames()
    {
        yield 'Benedict' => 1;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching key value generator (invalid value)
        Given the spec file "spec/Pamil/KeyValueGenerator3Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator3Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator3.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator3
{
    public function generateNames()
    {
        yield 'John' => 0;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Positive matching key value generator failing if generator has less elements than expected
        Given the spec file "spec/Pamil/KeyValueGenerator4Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator4Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator4.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator4
{
    public function generateNames()
    {
        yield 'John' => 1;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Expected 2 elements, but only 1 was generated'

    Scenario: Positive matching key value generator failing if generator has unexpected elements (invalid key)
        Given the spec file "spec/Pamil/KeyValueGenerator5Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator5Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator5.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator5
{
    public function generateNames()
    {
        yield 'John' => 1;
        yield 'Benedict' => 2;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Element #1 was expected to have key "Paul" with value [integer:2], but key "Benedict" with value [integer:2] was given'

    Scenario: Positive matching key value generator failing if generator has unexpected elements (invalid value)
        Given the spec file "spec/Pamil/KeyValueGenerator6Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator6Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator6.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator6
{
    public function generateNames()
    {
        yield 'John' => 1;
        yield 'Paul' => 0;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Element #1 was expected to have key "Paul" with value [integer:2], but key "Paul" with value [integer:0] was given'

    Scenario: Negative matching key value generator failing if generated elements matches the not expected ones
        Given the spec file "spec/Pamil/KeyValueGenerator7Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator7Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerate(['John' => 1], ['Paul' => 2]);
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator7.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator7
{
    public function generateNames()
    {
        yield 'John' => 1;
        yield 'Paul' => 2;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should not pass
        And I should see 'Generated elements are the same as not expected elements'

    Scenario: Positive matching key value generator for not generating anything
        Given the spec file "spec/Pamil/KeyValueGenerator8Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator8Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate();
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator8.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator8
{
    public function generateNames()
    {
        return new \ArrayIterator([]);
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Negative matching key value generator for not generating anything
        Given the spec file "spec/Pamil/KeyValueGenerator9Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator9Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerate();
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator9.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator9
{
    public function generateNames()
    {
        yield 'High Sparrow' => 42;
    }
}
    """
        When I run phpspec using the tap format
        Then the suite should pass

    Scenario: Positive matching key value generator for not generating anything failing
        Given the spec file "spec/Pamil/KeyValueGenerator10Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class KeyValueGenerator10Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate();
    }
}
    """
        And the class file "src/Pamil/KeyValueGenerator10.php" contains:
    """
<?php

namespace Pamil;

class KeyValueGenerator10
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
