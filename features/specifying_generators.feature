Feature: Specifying generators using PhpSpecGeneratorExtension
    In order to specify generators
    I need to enable PhpSpecGeneratorExtension

    Background:
        Given the config file contains:
    """
extensions:
    - Pamil\PhpSpecGeneratorExtension\Extension
    """

    Scenario: Positive matching generator
        Given the spec file "spec/Pamil/Generator1Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class Generator1Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John', 'Paul']);
    }
}
    """
        And the class file "src/Pamil/Generator1.php" contains:
    """
<?php

namespace Pamil;

class Generator1
{
    public function generateNames()
    {
        yield 'John';
        yield 'Paul';
    }
}
    """
        When I run phpspec
        Then the suite should pass

    Scenario: Negative matching generator
        Given the spec file "spec/Pamil/Generator2Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class Generator2Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerate(['John', 'Paul']);
    }
}
    """
        And the class file "src/Pamil/Generator2.php" contains:
    """
<?php

namespace Pamil;

class Generator2
{
    public function generateNames()
    {
        yield 'Benedict';
    }
}
    """
        When I run phpspec
        Then the suite should pass

    Scenario: Positive matching generator failing if generator has less elements than expected
        Given the spec file "spec/Pamil/Generator3Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class Generator3Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John', 'Paul']);
    }
}
    """
        And the class file "src/Pamil/Generator3.php" contains:
    """
<?php

namespace Pamil;

class Generator3
{
    public function generateNames()
    {
        yield 'Benedict';
    }
}
    """
        When I run phpspec
        Then the suite should not pass
        And I should see 'expected 2 elements, but only 1 was generated'

    Scenario: Positive matching generator failing if generator has unexpected elements
        Given the spec file "spec/Pamil/Generator4Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class Generator4Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldGenerate(['John', 'Paul']);
    }
}
    """
        And the class file "src/Pamil/Generator4.php" contains:
    """
<?php

namespace Pamil;

class Generator4
{
    public function generateNames()
    {
        yield 'John';
        yield 'Benedict';
    }
}
    """
        When I run phpspec
        Then the suite should not pass
        And I should see 'element #1 was expected to be "Paul", but "Benedict" was given'

    Scenario: Negative matching generator failing if generated elements matches the not expected ones
        Given the spec file "spec/Pamil/Generator5Spec.php" contains:
    """
<?php

namespace spec\Pamil;

use PhpSpec\ObjectBehavior;

class Generator5Spec extends ObjectBehavior
{
    function it_generates_names()
    {
        $this->generateNames()->shouldNotGenerate(['John', 'Paul']);
    }
}
    """
        And the class file "src/Pamil/Generator5.php" contains:
    """
<?php

namespace Pamil;

class Generator5
{
    public function generateNames()
    {
        yield 'John';
        yield 'Paul';
    }
}
    """
        When I run phpspec
        Then the suite should not pass
        And I should see 'generated elements are the same as not expected elements'
