<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateKeysMatcher extends AbstractGenerateMatcher
{
    /**
     * {@inheritdoc}
     */
    public function supports($name, $subject, array $arguments)
    {
        return 'generateKeys' === $name;
    }

    /**
     * {@inheritdoc}
     */
    protected function doMatch($name, \Iterator $subject, $expected, $elementNumber)
    {
        $actual = $subject->key();
        if ($expected !== $actual) {
            throw new FailureException(sprintf(
                'Element #%d was expected to have key %s, but %s was given.',
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
        throw new FailureException('Generated keys are the same as not expected keys.');
    }
}
