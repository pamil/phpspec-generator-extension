<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateMatcher extends AbstractGenerateMatcher
{
    /**
     * {@inheritdoc}
     */
    public function supports($name, $subject, array $arguments)
    {
        return 'generate' === $name;
    }

    /**
     * {@inheritdoc}
     */
    protected function doMatch($name, \Iterator $subject, $expected, $elementNumber)
    {
        list($expectedKey, $expectedValue) = $this->castArgumentToKeyValueTuple($expected);

        $actualKey = $subject->key();
        $actualValue = $subject->current();
        if ($expectedKey !== $actualKey || $expectedValue !== $actualValue) {
            throw new FailureException(sprintf(
                'Element #%d was expected to have key %s with value %s, but key %s with value %s was given.',
                $elementNumber,
                $this->presenter->presentValue($expectedKey),
                $this->presenter->presentValue($expectedValue),
                $this->presenter->presentValue($actualKey),
                $this->presenter->presentValue($actualValue)
            ));
        }
    }

    /**
     * {@inheritdoc}
     */
    protected function handleNegativeMatchFailure($name, $subject, array $arguments)
    {
        throw new FailureException('Generated elements are the same as not expected elements.');
    }

    /**
     * @param array $argument
     *
     * @return array
     *
     * @throws FailureException
     */
    private function castArgumentToKeyValueTuple(array $argument)
    {
        switch (count($argument)) {
            case 1:
                return [key($argument), current($argument)];
            case 2:
                return $argument;
        }

        throw new FailureException(sprintf(
            'Cannot match against %s expected argument.',
            $this->presenter->presentValue($argument)
        ));
    }
}
