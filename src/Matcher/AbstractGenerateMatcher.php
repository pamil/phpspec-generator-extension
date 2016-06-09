<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
abstract class AbstractGenerateMatcher implements MatcherInterface
{
    /**
     * @var Presenter
     */
    protected $presenter;

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
    public function positiveMatch($name, $subject, array $arguments)
    {
        if (!$subject instanceof \Iterator) {
            throw new \InvalidArgumentException('Subject should be an instance of \Iterator.');
        }

        $toGenerate = count($arguments);
        $elementNumber = 0;
        foreach ($arguments as $expected) {
            if (!$subject->valid()) {
                throw new FailureException(sprintf(
                    'Expected %d elements, but only %d was generated.',
                    $toGenerate,
                    $elementNumber
                ));
            }

            $this->doMatch($name, $subject, $expected, $elementNumber);

            $subject->next();
            ++$elementNumber;
        }

        if (0 === $elementNumber && $subject->valid()) {
            throw new FailureException('Expected not to generate any elements, but the iterator is still valid.');
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

       $this->handleNegativeMatchFailure($name, $subject, $arguments);
    }

    /**
     * {@inheritdoc}
     */
    public function getPriority()
    {
        return 100;
    }

    /**
     * @param string $name
     * @param \Iterator $subject
     * @param mixed $expected
     * @param int $elementNumber
     *
     * @throws FailureException
     */
    abstract protected function doMatch($name, \Iterator $subject, $expected, $elementNumber);

    /**
     * @param string $name
     * @param mixed $subject
     * @param array $arguments
     *
     * @throws FailureException
     */
    abstract protected function handleNegativeMatchFailure($name, $subject, array $arguments);
}
