<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateValuesMatcher extends AbstractGenerateMatcher
{
    /**
     * {@inheritdoc}
     */
    public function supports($name, $subject, array $arguments)
    {
        return 'generateValues' === $name;
    }

    /**
     * {@inheritdoc}
     */
    protected function doMatch($name, \Iterator $subject, $expected, $elementNumber)
    {
        $actual = $subject->current();
        if ($expected !== $actual) {
            throw new FailureException(sprintf(
                'Element #%d was expected to be %s, but %s was given.',
                $elementNumber,
                $this->presenter->presentValue($expected),
                $this->presenter->presentValue($actual)
            ));
        }
    }

    /**
     * {@inheritdoc}
     */
    protected function handleNegativeMatchFailure($name, $subject, array $arguments)
    {
        throw new FailureException('Generated values are the same as not expected values.');
    }
}

