<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateMatcher implements MatcherInterface
{
    /**
     * @var Presenter
     */
    private $presenter;

    /**
     * @param Presenter $presenter
     */
    public function __construct(Presenter $presenter)
    {
        $this->presenter = $presenter;
    }

    /**
     * {@inheritdoc}
     */
    public function supports($name, $subject, array $arguments)
    {
        return 'generate' === $name && 1 === count($arguments);
    }

    /**
     * {@inheritdoc}
     */
    public function positiveMatch($name, $subject, array $arguments)
    {
        $expected = $arguments[0];
        $actual = $this->match($subject, count($expected));

        if (count($expected) !== count($actual)) {
            throw new FailureException(sprintf(
                'Expected %d elements, but only %d was generated.',
                count($expected),
                count($actual)
            ));
        }

        for ($i = 0; $i < count($expected); ++$i) {
            if ($expected[$i] !== $actual[$i]) {
                throw new FailureException(sprintf(
                    'Element #%d was expected to be %s, but %s was given.',
                    $i,
                    $this->presenter->presentValue($expected[$i]),
                    $this->presenter->presentValue($actual[$i])
                ));
            }
        }
    }

    /**
     * {@inheritdoc}
     */
    public function negativeMatch($name, $subject, array $arguments)
    {
        try {
            $this->positiveMatch($name, $subject, $arguments);
        } catch (FailureException $exception) {
            return;
        }

        throw new FailureException('Generated elements are the same as not expected elements.');
    }

    /**
     * {@inheritdoc}
     */
    public function getPriority()
    {
        return 100;
    }

    /**
     * @param mixed $subject
     * @param int $amount
     *
     * @return array
     *
     * @throws FailureException
     */
    protected function match($subject, $amount)
    {
        if (!$subject instanceof \Generator) {
            throw new FailureException('Subject should be an instance of \Generator.');
        }

        $actual = [];
        for ($i = 0, $subject->rewind(); $i < $amount && $subject->valid(); ++$i, $subject->next()) {
            $actual[] = $subject->current();
        }

        return $actual;
    }
}
